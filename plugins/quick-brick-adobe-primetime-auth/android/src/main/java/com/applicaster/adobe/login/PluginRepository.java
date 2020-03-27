package com.applicaster.adobe.login;

import com.applicaster.adobe.login.model.PluginConfig;

import java.util.List;

import io.reactivex.Observable;

public interface PluginRepository {

    void setPluginConfiguration(PluginConfig pluginConfig);

    PluginConfig getPluginConfig();

    void setMvdpsList(List<String> mvpds);

    List<String> getMvdpsList();

}
