//
//  WebLoginViewController.swift
//  AdobeAccessEnablerQB
//
//  Created by brel on 3/24/20.
//

import UIKit
import WebKit
import AccessEnabler

class WebLoginViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet var navigationBar: UIView!
    var webView = WKWebView()
    let adobePassWebURL = "adobepass://ios.app"
    var accessEnabler: AccessEnabler?
    var cancelAction: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webView)
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
    @IBAction func cancel(_ sender: Any) {
        cancelAction?()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: ((WKNavigationActionPolicy) -> Void)) {

        guard let urlString = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        
        if urlString.absoluteString == adobePassWebURL {
            accessEnabler?.handleExternalURL(urlString.description)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
}
