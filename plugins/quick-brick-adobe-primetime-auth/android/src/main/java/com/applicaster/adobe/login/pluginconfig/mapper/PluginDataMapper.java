package com.applicaster.adobe.login.pluginconfig.mapper;

import com.applicaster.adobe.login.pluginconfig.model.PluginConfig;
import com.facebook.react.bridge.ReadableMap;

public class PluginDataMapper {
    public PluginConfig mapParamsToConfig(ReadableMap params) {
        String baseUrl = params.getString("base_url");
        String softwareStatement =  params.getString("software_statement");
        String requestorID = params.getString("requestor_id");
        String resourceID =  params.getString("resource_id");
        String redirectUri =  params.getString("redirect_uri");

        return new PluginConfig(baseUrl, softwareStatement, requestorID, resourceID, redirectUri);
    }
}