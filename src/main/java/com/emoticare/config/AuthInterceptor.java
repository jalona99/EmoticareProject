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
            if (user.getRoleId() != 4) { // 4 is Admin
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
                return false;
            }
        }

        return true;
    }
}
