package com.applicaster.adobe.login.pluginconfig;

import com.applicaster.adobe.login.pluginconfig.model.PluginConfig;

public interface PluginRepository {
    void setPluginConfiguration(PluginConfig pluginConfig);
    PluginConfig getPluginConfig();
}
