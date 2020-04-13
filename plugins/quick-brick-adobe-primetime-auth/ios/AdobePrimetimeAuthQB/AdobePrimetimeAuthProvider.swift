//
//  AdobePrimetimeAuthProvider.swift
//  AdobeAccessEnablerQB
//
//  Created by brel on 3/24/20.
//
import React
import Foundation
import AccessEnabler
import ZappCore

enum AdobeFlow {
    case login
    case logout
    case none
}

@objc(AdobePrimetimeAuthProvider)
class AdobePrimetimeAuthProvider: RCTEventEmitter, EntitlementDelegate, EntitlementStatus {
    
    var flow = AdobeFlow.none
    var webLoginViewController: WebLoginViewController?
    var pluginConfig: [String: String]?
    var additionalParameters: [String: Any]?
    var accessEnabler = AccessEnabler()
    var resourceID: String?
    var authCompletion: RCTResponseSenderBlock?

    @objc func setupAccessEnabler(_ pluginConfig: [String: String]) {
        self.pluginConfig = pluginConfig
        accessEnabler = AccessEnabler(pluginConfig["software_statement"] ?? "")
        accessEnabler.delegate = self
        accessEnabler.statusDelegate = self
        accessEnabler.setRequestor(pluginConfig["requestor_id"] ?? "")
        self.resourceID = pluginConfig["resource_id"]
    }
    
    @objc func startLoginFlow(_ additionalParameters: [String: Any], callback: @escaping RCTResponseSenderBlock) {
        flow = .login
        self.authCompletion = callback
        self.additionalParameters = additionalParameters
        self.accessEnabler.checkAuthentication()
    }
    
    @objc func logout(_ callback: @escaping RCTResponseSenderBlock) {
        flow = .logout
        self.authCompletion = callback
        self.accessEnabler.logout()
        let cookieStorage = HTTPCookieStorage.shared
        if let cookies = cookieStorage.cookies {
            for cookie in cookies {
                cookieStorage.deleteCookie(cookie as HTTPCookie)
            }
        }
        accessEnabler.checkAuthentication()
    }
    
    @objc func setProviderID(_ providerID: String) {
        self.accessEnabler.setSelectedProvider(providerID)
    }
    
    func setAuthenticationStatus(_ status: Int32, errorCode code: String!) {
        switch status {
        case ACCESS_ENABLER_STATUS_SUCCESS:
            _ = FacadeConnector.connector?.storage?.localStorageSetValue(for: "idToken", value: "authToken", namespace: nil)
            if let stringForAuthorization = getResourceStringForAuthorization() {
                self.accessEnabler.getAuthorization(stringForAuthorization)
            } else {
                finishFlow()
            }
        case ACCESS_ENABLER_STATUS_ERROR:
            if code == USER_NOT_AUTHENTICATED_ERROR && flow == .logout {
                _ = FacadeConnector.connector?.storage?.localStorageSetValue(for: "idToken", value: "\"{}\"", namespace: nil)
                finishFlow()
            } else {
                accessEnabler.getAuthentication()
            }
        default:
            break
        }
    }
    
    func setToken(_ token: String!, forResource resource: String!) {
        finishFlow(token)
    }
    
    func tokenRequestFailed(_ resource: String!, errorCode code: String!, errorDescription description: String!) {
        if flow == .login {
            let message = "This content is not included in your package"
            let okText = "OK"
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: okText, style: .default, handler: { _ in
                self.finishFlow()
            }))
            let topViewController = UIViewController.topmostViewController()
            topViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    func displayProviderDialog(_ mvpds: [Any]!) {
        guard let providers = mvpds as? [MVPD] else {
            return
        }
        sendEvent(withName: "showProvidersList", body: providers.toJSONObjects())
    }
    
    func navigate(toUrl url: String!) {
        if flow == .login  {
            webLoginViewController = WebLoginViewController.instantiateVC()
            webLoginViewController?.accessEnabler = accessEnabler
            webLoginViewController?.modalPresentationStyle = .fullScreen
            webLoginViewController?.cancelAction = { [weak self] in
                self?.finishFlow()
            }
            showWebView(url: url)
        }
    }
    
    func dismissWebView() {
        webLoginViewController?.dismiss(animated: true, completion: {
            self.webLoginViewController = nil
        })
    }
    
    func showWebView(url: String) {
        guard let viewController = webLoginViewController else {
            return
        }
        let topViewController = UIViewController.topmostViewController()
        topViewController?.present(viewController, animated: true, completion: {
            guard let url = URL(string: url) else {return}
            viewController.webView.load(URLRequest(url: url))
        })
    }
    
    func finishFlow(_ token: String? = nil) {
        dismissWebView()
        if flow == .login {
            token == nil ? authCompletion?([]) : authCompletion?([["token": token]])
        } else {
            authCompletion?([])
        }
        authCompletion = nil
        flow = .none
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
    
    func preauthorizedResources(_ resources: [Any]!) {
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
