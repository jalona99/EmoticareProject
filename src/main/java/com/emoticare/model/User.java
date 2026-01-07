package com.emoticare.model;

import java.time.LocalDateTime;
import jakarta.validation.constraints.*;

public class User {
    private Integer id;
    
    @NotBlank(message = "Username tidak boleh kosong")
    @Size(min = 3, max = 100, message = "Username harus 3-100 karakter")
    @Pattern(regexp = "^[a-zA-Z0-9._-]+$", message = "Username hanya boleh mengandung huruf, angka, titik, dan garis miring")
    private String username;
    
    @NotBlank(message = "Email tidak boleh kosong")
    @Email(message = "Format email tidak valid")
    private String email;
    
    @NotBlank(message = "Password tidak boleh kosong")
    @Size(min = 8, message = "Password minimal 8 karakter")
    @Pattern(
        regexp = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[a-zA-Z\\d@$!%*?&]{8,}$",
        message = "Password harus mengandung uppercase, lowercase, angka, dan simbol khusus"
    )
    private String password;
    
    private String confirmPassword;
    
    @NotNull(message = "Role harus dipilih")
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
