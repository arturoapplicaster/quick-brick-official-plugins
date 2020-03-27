package com.applicaster.adobe.login;

import android.app.AlertDialog;
import android.content.DialogInterface;

import com.adobe.adobepass.accessenabler.models.Mvpd;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import javax.annotation.Nonnull;

public class AdobePassContract extends ReactContextBaseJavaModule {

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

    //TODO: Dummy call. Rework
    public void onProviderSelected(Mvpd mvpd){
        AccessEnablerHandler.INSTANCE.getAccessEnabler().setSelectedProvider(mvpd.getId());
    }
}
