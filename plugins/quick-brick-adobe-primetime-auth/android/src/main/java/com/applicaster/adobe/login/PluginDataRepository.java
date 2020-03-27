package com.applicaster.adobe.login;

import com.applicaster.adobe.login.model.PluginConfig;

import java.util.ArrayList;
import java.util.List;

import io.reactivex.Observable;
import io.reactivex.Observer;

public enum PluginDataRepository implements PluginRepository {
    INSTANCE;

    private PluginConfig pluginConfig;
    List<String> mvpds = new ArrayList<>();

    @Override
    public void setPluginConfiguration(PluginConfig pluginConfig) {
        this.pluginConfig = pluginConfig;
    }

    @Override
    public PluginConfig getPluginConfig() {
        return pluginConfig;
    }

    @Override
    public void setMvdpsList(List<String> mvpds) {
        this.mvpds = mvpds;
    }

    @Override
    public List<String> getMvdpsList() {
        return mvpds;
    }
}
