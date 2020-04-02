package com.applicaster.adobe.login.webview;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.webkit.WebView;
import android.widget.ProgressBar;

import com.applicaster.adobe.login.R;
import com.applicaster.adobe.login.ReactSession;

public class LoginProviderActivity extends AppCompatActivity implements LoginFinishCallback {

    private static final String ARG_URL = "url";

    private String url;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login_provider);

        if (getIntent() != null) {
            this.url = getIntent().getStringExtra(ARG_URL);
        }

        WebView webView = findViewById(R.id.web_view_login);
        ProgressBar pbLoadingProgress = findViewById(R.id.web_view_loading_progress);

        webView.getSettings().setJavaScriptEnabled(true);
        webView.setWebViewClient(new LoginWebViewClient(this, this));
        webView.setWebChromeClient(new LoginWebChromeClient(pbLoadingProgress));
        webView.loadUrl(url);
    }

    @Override
    public void onLoginFinished() {
        finish();
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        ReactSession.INSTANCE.triggerCallbackFail();
    }
}