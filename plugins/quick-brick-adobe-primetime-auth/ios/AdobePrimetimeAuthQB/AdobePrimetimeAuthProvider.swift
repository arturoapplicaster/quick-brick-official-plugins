//
//  AdobePrimetimeAuthProvider.swift
//  AdobeAccessEnablerQB
//
//  Created by brel on 3/24/20.
//
import React
import Foundation
import AccessEnabler

@objc(AdobePrimetimeAuthProvider)
class AdobePrimetimeAuthProvider: RCTEventEmitter, EntitlementDelegate, EntitlementStatus {
    static let shared = AdobePrimetimeAuthProvider()
    var webLoginViewController: WebLoginViewController?
    var additionalParameters: [String: Any]?
    var accessEnabler = AccessEnabler()
    var resourceID: String?
    // User authenticated in adobe access enabler
    var userAuthenticated = false
    // Tokens dictionary - keys are the resource IDs
    var tokensDictionary: [String:String] = [:]
    // Authorized resource
    var authorizedResourceIDs: [String] = []
    // Authorization flow completion
    var authCompletion: RCTResponseSenderBlock?
    
    @objc func setupAccessEnabler(_ pluginConfig: [String: String]) {
       accessEnabler = AccessEnabler(pluginConfig["software_statement"] ?? "")
       accessEnabler.delegate = self
       accessEnabler.statusDelegate = self
       var providers = [String]()
       if let url = pluginConfig["base_url"] {
           providers.append(url)
       }
       accessEnabler.setRequestor(pluginConfig["requestor_id"] ?? "")
       self.resourceID = pluginConfig["resource_id"]
    }
    
    @objc func startLoginFlow(_ additionalParameters: [String: Any], callback: @escaping RCTResponseSenderBlock) {
        self.authCompletion = callback
        self.additionalParameters = additionalParameters
        if self.userAuthenticated {
            if let stringForAuthorization = getResourceStringForAuthorization() {
                self.accessEnabler.getAuthorization(stringForAuthorization)
            }
        } else {
            self.accessEnabler.getAuthentication()
        }
    }
    
    @objc func logout() {
       self.userAuthenticated = false
       self.tokensDictionary = [:]
       self.authorizedResourceIDs = []
       self.accessEnabler.logout()
       // Delete cookies from UIWebView as well in case someone clicked remember me
       let cookieStorage = HTTPCookieStorage.shared
       if let cookies = cookieStorage.cookies {
           for cookie in cookies {
               cookieStorage.deleteCookie(cookie as HTTPCookie)
           }
       }
    }
    
    @objc func setProviderID(_ providerID: String) {
        self.accessEnabler.setSelectedProvider(providerID)
    }
    
    func setAuthenticationStatus(_ status: Int32, errorCode code: String!) {
        if status == ACCESS_ENABLER_STATUS_SUCCESS {
            self.userAuthenticated = true
            if self.resourceID != nil {
                if let stringForAuthorization = getResourceStringForAuthorization() {
                    self.accessEnabler.getAuthorization(stringForAuthorization)
                }
            } else {
                finishLoginFlow()
            }
        } else {
            self.userAuthenticated = false
            if code == PROVIDER_NOT_SELECTED_ERROR {
                finishLoginFlow()
            } else {
                finishLoginFlow()
            }
            authCompletion = nil
        }
    }
    
    func setToken(_ token: String!, forResource resource: String!) {
        guard let itemID = additionalParameters?["itemID"] as? String else { return }
        if let token = token,
            let resource = resource {
            self.tokensDictionary[itemID] = token
            self.authorizedResourceIDs.append(resource)
        }
        if self.authCompletion != nil, self.userAuthenticated {
            finishLoginFlow(token)
        }
    }
    
    func preauthorizedResources(_ resources: [Any]!) {
        if let resourceStringsArray = resources as? [String] {
            authorizedResourceIDs.append(contentsOf: resourceStringsArray)
        }
    }
    
    func tokenRequestFailed(_ resource: String!, errorCode code: String!, errorDescription description: String!) {
        userAuthenticated = false
        if self.authCompletion != nil {
            let message = "This content is not included in your package"
            let okText = "OK"
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: okText, style: .default, handler: { _ in
                self.finishLoginFlow()
            }))
            webLoginViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    func displayProviderDialog(_ mvpds: [Any]!) {
        guard let providers = mvpds as? [MVPD] else {
            return
        }
        sendEvent(withName: "showProvidersList", body: providers.toJSONObjects())
    }
    
    func navigate(toUrl url: String!) {
        if webLoginViewController != nil || authCompletion == nil  {
            return
        }
        webLoginViewController = WebLoginViewController.instantiateVC()
        webLoginViewController?.accessEnabler = accessEnabler
        webLoginViewController?.modalPresentationStyle = .fullScreen
        webLoginViewController?.cancelAction = { [weak self] in
            self?.finishLoginFlow()
        }
        let topViewController = UIViewController.topmostViewController()
        guard let webLoginViewController = webLoginViewController else {
            return
        }
        topViewController?.present(webLoginViewController, animated: true, completion: {
            guard let url = URL(string: url) else {return}
            webLoginViewController.webView.load(URLRequest(url: url))
        })
    }
    
    func dismissWebView() {
        webLoginViewController?.dismiss(animated: true, completion: {
            self.webLoginViewController = nil
        })
    }
    
    func finishLoginFlow(_ token: String? = nil) {
        dismissWebView()
        guard let token = token else {
            authCompletion?([])
            authCompletion = nil
            return
        }
        authCompletion?([NSNull(), ["token": token]])
        authCompletion = nil
    }
    
    //MARK:- Unused Delegate methods
    
    func setRequestorComplete(_ status: Int32) {
        //empty
    }
    
    func selectedProvider(_ mvpd: MVPD!) {
        //empty
    }
    
    func sendTrackingData(_ data: [Any]!, forEventType event: Int32) {
        //empty
    }
    
    func setMetadataStatus(_ metadata: Any!, encrypted: Bool, forKey key: Int32, andArguments arguments: [AnyHashable : Any]!) {
        //empty
    }
    
    func presentTvProviderDialog(_ viewController: UIViewController!) {
        //empty
    }
    
    func dismissTvProviderDialog(_ viewController: UIViewController!) {
        //empty
    }
    
    func status(_ statusDictionary: [AnyHashable : Any]!) {
        //empty
    }
    
    //MARK:- helper method to get resourceId string
    private func getResourceStringForAuthorization() -> String? {
        guard let resourceID = self.resourceID,
              let itemID = additionalParameters?["itemID"] as? String,
              let itemTitle = additionalParameters?["itemTitle"] as? String
            else {
            return nil
        }
        return "<rss version=\"2.0\" xmlns:media=\"http://search.yahoo.com/mrss/\"><channel><title>\(resourceID)</title><item><title>\(itemTitle)</title><guid>\(itemID)</guid></item></channel></rss>"
    }
    
    //MARK:- React native support
    
    override open var methodQueue: DispatchQueue {
        return DispatchQueue.main
    }
    
    override class func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    override func supportedEvents() -> [String]! {
      return ["showProvidersList"]
    }
}
