package com.applicaster.adobe.login.model;

public class PluginConfig {

    private final String baseUrl;
    private final String softwareStatement;
    private final String requestorID;
    private final String resourceID;
    private final String redirectUri;


    public PluginConfig(String baseUrl,
                        String softwareStatement,
                        String requestorID,
                        String resourceID,
                        String redirectUri) {
        this.baseUrl = baseUrl;
        this.softwareStatement = softwareStatement;
        this.requestorID = requestorID;
        this.resourceID = resourceID;
        this.redirectUri = redirectUri;
    }

    public String getBaseUrl() {
        return baseUrl;
    }

    public String getSoftwareStatement() {
        return softwareStatement;
    }

    public String getRequestorID() {
        return requestorID;
    }

    public String getResourceID() {
        return resourceID;
    }

    public String getRedirectUri() {
        return redirectUri;
    }
}
