package com.applicaster.adobe.login.webview;

import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.widget.ProgressBar;

public class LoginWebChromeClient extends WebChromeClient {

    private ProgressBar pbLoadingProgress;

    public LoginWebChromeClient(ProgressBar pbLoadingProgress) {
        this.pbLoadingProgress = pbLoadingProgress;
    }

    @Override
    public void onProgressChanged(WebView view, int newProgress) {
        if (newProgress < 100 && pbLoadingProgress.getVisibility() == ProgressBar.GONE) {
            pbLoadingProgress.setVisibility(ProgressBar.VISIBLE);
        }
        pbLoadingProgress.setProgress(newProgress);
        if (newProgress == 100) {
            pbLoadingProgress.setVisibility(ProgressBar.GONE);
        }
    }
}
