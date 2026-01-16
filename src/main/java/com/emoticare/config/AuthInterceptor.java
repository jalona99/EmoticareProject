package com.emoticare.config;

import com.emoticare.model.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.servlet.HandlerInterceptor;

public class AuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        String uri = request.getRequestURI();

        // Public pages (Login, Register, Helpers) - Though Interceptor registration
        // usually handles exclusions
        if (uri.contains("/login") || uri.contains("/register") || uri.contains("/resources")) {
            return true;
        }

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        // Role Checks
        if (uri.contains("/admin")) {
            boolean authorized = false;
            
            System.out.println("--- [AuthInterceptor Debug Start] ---");
            System.out.println("URI: " + uri);
            System.out.println("Session ID: " + session.getId());
            
            // Log all session attributes
            java.util.Enumeration<String> attrs = session.getAttributeNames();
            while (attrs.hasMoreElements()) {
                String name = attrs.nextElement();
                Object val = session.getAttribute(name);
                System.out.println("Session Attr: " + name + " = " + val + " (Type: " + (val != null ? val.getClass().getName() : "null") + ")");
            }

            if (user != null) {
                Integer roleFromUser = user.getRoleId();
                System.out.println("Role from User object: " + roleFromUser);
                if (roleFromUser != null && roleFromUser.equals(4)) {
                    authorized = true;
                }
            }
            
            if (!authorized) {
                Integer roleFromSession = (Integer) session.getAttribute("roleId");
                System.out.println("Role from Session attr: " + roleFromSession);
                if (roleFromSession != null && roleFromSession.equals(4)) {
                    authorized = true;
                }
            }

            System.out.println("Final Authorization Result: " + authorized);
            System.out.println("--- [AuthInterceptor Debug End] ---");

            if (!authorized) {
                System.out.println("[AuthInterceptor] ACCESS DENIED: User is not an admin");
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied - Admin Role Required");
                return false;
            }
            System.out.println("[AuthInterceptor] ACCESS GRANTED");
        }

        return true;
    }
}
