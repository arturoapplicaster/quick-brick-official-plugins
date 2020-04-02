package com.applicaster.adobe.login.pluginconfig;


import com.applicaster.adobe.login.pluginconfig.model.PluginConfig;

public enum PluginDataRepository implements PluginRepository {
    INSTANCE;

    private PluginConfig pluginConfig;

    @Override
    public void setPluginConfiguration(PluginConfig pluginConfig) {
        this.pluginConfig = pluginConfig;
    }

    @Override
    public PluginConfig getPluginConfig() {
        return pluginConfig;
    }
}