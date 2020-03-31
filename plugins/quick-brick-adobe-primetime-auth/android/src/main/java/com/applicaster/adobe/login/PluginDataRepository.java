package com.applicaster.adobe.login;

import com.adobe.adobepass.accessenabler.models.Mvpd;
import com.applicaster.adobe.login.model.PluginConfig;

import java.util.ArrayList;
import java.util.List;

public enum PluginDataRepository implements PluginRepository {
    INSTANCE;

    private PluginConfig pluginConfig;
    List<Mvpd> mvpds = new ArrayList<>();

    @Override
    public void setPluginConfiguration(PluginConfig pluginConfig) {
        this.pluginConfig = pluginConfig;
    }

    @Override
    public PluginConfig getPluginConfig() {
        return pluginConfig;
    }

    @Override
    public void setMvdpsList(ArrayList<Mvpd> mvpds) {
        this.mvpds = mvpds;
    }

    @Override
    public List<Mvpd> getMvdpsList() {
        return mvpds;
    }
}
