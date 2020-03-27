package com.applicaster.adobe.login;

import android.content.Context;

import com.applicaster.adobe.login.mapper.PluginDataMapper;
import com.applicaster.plugin_manager.login.LoginContract;
import com.applicaster.plugin_manager.playersmanager.Playable;

import java.util.Map;

public class AdobePassLoginContract{

    private final AdobePassLoginHandler adobePassLoginHandler;
    private final PluginRepository pluginRepository;

    public AdobePassLoginContract() {
        pluginRepository = PluginDataRepository.INSTANCE;
        adobePassLoginHandler = new AdobePassLoginHandler(PluginDataRepository.INSTANCE,
                AccessEnablerHandler.INSTANCE);
    }

    public void setPluginConfigurationParams(Map params) {
        PluginDataMapper dataMapper = new PluginDataMapper();
        pluginRepository.setPluginConfiguration(dataMapper.mapParamsToConfig(params));
        adobePassLoginHandler.initializeAccessEnabler();
    }

    public boolean handlePluginScheme(Context context, Map<String, String> data) {
        boolean wasHandled = false;
        if (verifiedPluginSchema(data)) {
            adobePassLoginHandler.displayLogoutAlertDialog(context);
            wasHandled = true;
        }
        return wasHandled;
    }

    private boolean verifiedPluginSchema(Map<String, String> data) {
        boolean verified = false;
        if ("login".equals(data.get("type"))) {
            if ("logout".equals(data.get("action"))) {
                verified = true;
            }
        }

        return verified;
    }


    public void login(Context context, Playable playable, Map additionalParams, final LoginContract.Callback callback) {
        adobePassLoginHandler.login(context, playable, callback);
    }

    public void login(Context context, Map additionalParams, LoginContract.Callback callback) {
        adobePassLoginHandler.login(context, null, callback);
    }
}
