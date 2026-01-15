package com.emoticare.model;

public class ProfessionalProfile {
    private int id;
    private int userId;
    private String name;
    private String credentials;
    private String specialty;
    private String bio;
    private String calendlyUrl;

    public ProfessionalProfile() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getCredentials() { return credentials; }
    public void setCredentials(String credentials) { this.credentials = credentials; }

    public String getSpecialty() { return specialty; }
    public void setSpecialty(String specialty) { this.specialty = specialty; }

    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }

    public String getCalendlyUrl() { return calendlyUrl; }
    public void setCalendlyUrl(String calendlyUrl) { this.calendlyUrl = calendlyUrl; }
}
