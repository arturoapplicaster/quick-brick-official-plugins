package com.applicaster.adobe.login.webview;

import android.content.Context;
import android.util.Log;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import com.applicaster.adobe.login.AccessEnablerHandler;
import com.applicaster.adobe.login.PluginDataRepository;
import com.applicaster.adobe.login.R;
import com.applicaster.adobe.login.model.PluginConfig;

class LoginWebViewClient extends WebViewClient {

    String redirectUriScheme = "adobepass://";
    String redirectUri;
    LoginFinishCallback loginFinishCallback;

    public LoginWebViewClient(Context context, LoginFinishCallback callback) {
        this.loginFinishCallback = callback;
        this.redirectUri = getRedirectUri(context);
    }

    @Override
    public boolean shouldOverrideUrlLoading(WebView view, String url) {
        if (url.equals(redirectUri)) {
            Log.i(this.getClass().getName(), "Redirect url achieved: " + url + " :getAuthToken action preformed.");
            AccessEnablerHandler.INSTANCE.getAccessEnabler().getAuthenticationToken();
            loginFinishCallback.onLoginFinished();
        } else {
            view.loadUrl(url);
            return false;
        }
        return true;
    }

    private String getRedirectUri(Context context) {
        PluginConfig config = PluginDataRepository.INSTANCE.getPluginConfig();
        String redirectUri = config.getRedirectUri();
        if (redirectUri != null && !redirectUri.isEmpty()) {
            return redirectUriScheme + redirectUri;
        }
        return redirectUriScheme + context.getResources().getString(R.string.redirect_uri);
    }
}

