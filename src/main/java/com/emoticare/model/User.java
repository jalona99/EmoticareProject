package com.emoticare.model;

import java.time.LocalDateTime;
import jakarta.validation.constraints.*;

public class User {
    private Integer id;
    
    @NotBlank(message = "Username is required")
    @Size(min = 3, max = 100, message = "Username must be 3-100 characters")
    @Pattern(regexp = "^[a-zA-Z0-9._-]+$", message = "Username may only contain letters, numbers, dots, underscores, and hyphens")
    private String username;
    
    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email format")
    private String email;
    
    @NotBlank(message = "Password is required")
    @Size(min = 8, message = "Password must be at least 8 characters")
    @Pattern(
        regexp = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[a-zA-Z\\d@$!%*?&]{8,}$",
        message = "Password must include uppercase, lowercase, a number, and a special character"
    )
    private String password;
    
    private String confirmPassword;
    
    @NotNull(message = "Role must be selected")
    private Integer roleId;
    
    private Role role;
    private boolean isActive;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Constructors
    public User() {}

    public User(String username, String email, String password, Integer roleId) {
        this.username = username;
        this.email = email;
        this.password = password;
        this.roleId = roleId;
        this.isActive = true;
    }

    // Getters dan Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getConfirmPassword() { return confirmPassword; }
    public void setConfirmPassword(String confirmPassword) { this.confirmPassword = confirmPassword; }

    public Integer getRoleId() { return roleId; }
    public void setRoleId(Integer roleId) { this.roleId = roleId; }

    public Role getRole() { return role; }
    public void setRole(Role role) { this.role = role; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    @Override
    public String toString() {
        return "User{" + "id=" + id + ", username='" + username + '\'' + 
               ", email='" + email + '\'' + ", roleId=" + roleId + '}';
    }
}
