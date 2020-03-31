package com.applicaster.adobe.login;

import com.adobe.adobepass.accessenabler.models.Mvpd;
import com.applicaster.adobe.login.model.PluginConfig;

import java.util.ArrayList;
import java.util.List;

public interface PluginRepository {

    void setPluginConfiguration(PluginConfig pluginConfig);

    PluginConfig getPluginConfig();

    void setMvdpsList(ArrayList<Mvpd> mvpds);

    List<Mvpd> getMvdpsList();

}
