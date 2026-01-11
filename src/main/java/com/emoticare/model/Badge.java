package com.emoticare.model;

public class Badge {
    private int id;
    private String name;
    private String description;
    private String iconUrl;
    private Integer criteriaModuleId; // Optional, null if general badge

    public Badge() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getIconUrl() {
        return iconUrl;
    }

    public void setIconUrl(String iconUrl) {
        this.iconUrl = iconUrl;
    }

    public Integer getCriteriaModuleId() {
        return criteriaModuleId;
    }

    public void setCriteriaModuleId(Integer criteriaModuleId) {
        this.criteriaModuleId = criteriaModuleId;
    }
}
