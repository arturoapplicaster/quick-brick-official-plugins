package com.applicaster.adobe.login.mapper;

import com.applicaster.adobe.login.model.PluginConfig;
import com.facebook.react.bridge.ReadableMap;

import java.util.Map;

public class PluginDataMapper {

    public PluginConfig mapParamsToConfig(Map params) {
        String baseUrl = (String) params.get("base_url");
        String softwareStatement = (String) params.get("software_statement");
        String requestorID = (String) params.get("requestor_id");
        String resourceID = (String) params.get("resource_id");
        String redirectUri = (String) params.get("redirect_uri");

        return new PluginConfig(baseUrl, softwareStatement, requestorID, resourceID, redirectUri);
    }

    public PluginConfig mapParamsToConfig(ReadableMap params) {
        String baseUrl = params.getString("base_url");
        String softwareStatement =  params.getString("software_statement");
        String requestorID = params.getString("requestor_id");
        String resourceID =  params.getString("resource_id");
        String redirectUri =  params.getString("redirect_uri");

        return new PluginConfig(baseUrl, softwareStatement, requestorID, resourceID, redirectUri);
    }
}
