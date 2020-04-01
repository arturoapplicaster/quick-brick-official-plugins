package com.applicaster.adobe.login;

import com.applicaster.adobe.login.model.PluginConfig;

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