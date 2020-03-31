package com.applicaster.adobe.login;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.util.Log;

import com.applicaster.adobe.login.mapper.PluginDataMapper;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;

import javax.annotation.Nonnull;

public class AdobePassContract extends ReactContextBaseJavaModule {
    private static final String TAG = "AdobePassContract";
    private AdobePassLoginHandler adobePassLoginHandler;
    private PluginRepository pluginRepository;
    private static ReactApplicationContext reactContext;

    public AdobePassContract(@Nonnull ReactApplicationContext context) {
        super(context);
        reactContext = context;
    }

    @Nonnull
    @Override
    public String getName() {
        return "AdobePassContract";
    }

    @ReactMethod
    public void showToast() {
        AlertDialog.Builder alertDialog = new AlertDialog.Builder(getCurrentActivity());
        alertDialog.setTitle("Hello from java");
        alertDialog.setPositiveButton("Okay", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialogInterface, int i) {
                dialogInterface.dismiss();
            }
        });
        AlertDialog dialog = alertDialog.create();
        dialog.show();
    }

    @ReactMethod
    public void setupAccessEnabler(ReadableMap pluginConfig) {
        Log.d(TAG, "Call from RN: setupAccessEnabler " + pluginConfig);
        pluginRepository = PluginDataRepository.INSTANCE;
        adobePassLoginHandler = new AdobePassLoginHandler(PluginDataRepository.INSTANCE,
                AccessEnablerHandler.INSTANCE, reactContext);
        setPluginConfigurationParams(pluginConfig);
    }

    @ReactMethod
    public void startLoginFlow(final ReadableMap additionalConfig, final Callback callback) {
        Log.d(TAG, "Call from RN: startLoginFlow" + additionalConfig);
        if (getCurrentActivity() != null) {
            getCurrentActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    adobePassLoginHandler.login(getCurrentActivity(),
                            additionalConfig.getString("itemTitle"),
                            additionalConfig.getString("itemID"),
                            callback);
                }
            });
        }
    }

    @ReactMethod
    public void setProviderID(String providerID) {
        Log.d(TAG, "Call from RN: setProviderID " + providerID);
        AccessEnablerHandler.INSTANCE.getAccessEnabler().setSelectedProvider(providerID);
    }

    public void setPluginConfigurationParams(ReadableMap params) {
        PluginDataMapper dataMapper = new PluginDataMapper();
        pluginRepository.setPluginConfiguration(dataMapper.mapParamsToConfig(params));
        adobePassLoginHandler.initializeAccessEnabler();
    }
}
