package com.applicaster.adobe.login;

import com.applicaster.adobe.login.model.PluginConfig;

public interface PluginRepository {
    void setPluginConfiguration(PluginConfig pluginConfig);
    PluginConfig getPluginConfig();
}
