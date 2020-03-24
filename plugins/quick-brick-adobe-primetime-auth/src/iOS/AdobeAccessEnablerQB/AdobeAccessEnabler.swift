//
//  Counter.swift
//  AwesomeProject
//
//  Created by brel on 3/18/20.
//  Copyright © 2020 Facebook. All rights reserved.
//
import React
import Foundation
import AccessEnabler

@objc(AdobeAccessEnabler)
class AdobeAccessEnabler: RCTEventEmitter, EntitlementDelegate, EntitlementStatus {
    static let shared = AdobeAccessEnabler()
    var additionalParameters: [String: Any]?
    var playableItemId: String?
    var accessEnabler = AccessEnabler()
    var resourceID: String?
    // User authenticated in adobe access enabler
    var userAuthenticated = false
    // Selected tv provider - Can be used to get metadata to display in app
    public var selectedMVPD: MVPD?
    // Tokens dictionary - keys are the resource IDs
    var tokensDictionary: [String:String] = [:]
    // Authorized resource
    var authorizedResourceIDs: [String] = []
    // Authorization flow completion
    var authCallback: RCTResponseSenderBlock?
    
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
        authCallback = callback
        if self.userAuthenticated {
            if let stringForAuthorization = getResourceStringForAuthorization() {
                self.accessEnabler.getAuthorization(stringForAuthorization)
            }
        } else {
            if self.userAuthenticated,
                let resourceID = self.resourceID,
                self.authorizedResourceIDs.contains(resourceID) == false {
                if let stringForAuthorization = getResourceStringForAuthorization() {
                    self.accessEnabler.getAuthorization(stringForAuthorization)
                }
            } else {
                self.accessEnabler.getAuthentication()
            }
        }
    }
    
    @objc func setProviderID(_ providerID: String) {
        self.accessEnabler.setSelectedProvider(providerID)
    }
    
    func setAuthenticationStatus(_ status: Int32, errorCode code: String!) {
        if status == ACCESS_ENABLER_STATUS_SUCCESS {
            self.userAuthenticated = true
            if let _ = self.resourceID {
                if let stringForAuthorization = getResourceStringForAuthorization() {
                    self.accessEnabler.getAuthorization(stringForAuthorization)
                }
            } else {
                guard let authCallback = authCallback else {
                    return
                }
                authCallback(["failed"])
            }
        } else {
            self.userAuthenticated = false
            if code == PROVIDER_NOT_SELECTED_ERROR {
                guard let authCallback = authCallback else {
                    return
                }
                authCallback(["canceled"])
            } else {
                guard let authCallback = authCallback else {
                    return
                }
                authCallback(["failed"])
            }
            authCallback = nil
        }
    }
    
    func setToken(_ token: String!, forResource resource: String!) {
//        guard let playableItemId = self.playableItemId else { return }
//        if let token = token,
//            let resource = resource {
//            self.tokensDictionary[playableItemId] = token
//            self.authorizedResourceIDs.append(resource)
//        }
//
//        if let _ = self.authorizationCompletion,
//            self.userAuthenticated {
//
//            if let loadingViewController = self.loadingViewController  {
//                loadingViewController.dismissModalViewControllerFromParent(animated: true,
//                                                                                 completionHandler: {
//                                                                                    self.authorizationCompletion?(.completedSuccessfully)
//                                                                                    self.authorizationCompletion = nil
//                })
//            } else  {
//                self.authorizationCompletion?(.completedSuccessfully)
//                self.authorizationCompletion = nil
//            }
//            self.loadingViewController = nil
//        }
    }
    
    func preauthorizedResources(_ resources: [Any]!) {
        if let resourceStringsArray = resources as? [String] {
            self.authorizedResourceIDs.append(contentsOf: resourceStringsArray)
        }
    }
    
    func tokenRequestFailed(_ resource: String!, errorCode code: String!, errorDescription description: String!) {
        self.userAuthenticated = false
        guard let authCallback = authCallback else {
            return
        }
        authCallback(["failed"])
    }
    
    func selectedProvider(_ mvpd: MVPD!) {
        //empty ?
    }
    
    func displayProviderDialog(_ mvpds: [Any]!) {
        guard let providers = mvpds as? [MVPD] else {
            return
        }
        sendEvent(withName: "showProvidersList", body: providers.toJSONObjects())
    }
    
    func sendTrackingData(_ data: [Any]!, forEventType event: Int32) {
        //empty
    }
    
    func setMetadataStatus(_ metadata: Any!, encrypted: Bool, forKey key: Int32, andArguments arguments: [AnyHashable : Any]!) {
        //empty
    }
    
    func navigate(toUrl url: String!) {
        //Somehow send to JS
    }
    
    func presentTvProviderDialog(_ viewController: UIViewController!) {
        //empty ?
    }
    
    func dismissTvProviderDialog(_ viewController: UIViewController!) {
        //empty ?
    }
    
    func status(_ statusDictionary: [AnyHashable : Any]!) {
        //empty
    }
    
    func setRequestorComplete(_ status: Int32) {
        //empty
    }
    
    //MARK: helper method to get resourceId string
    private func getResourceStringForAuthorization() -> String? {
//        guard let resourceID = self.resourceID, let additionalParameters = self.additionalParameters else { return nil }
//        guard let playableItems = additionalParameters["playable_items"] as? [ZPPlayable], let itemToAuthorize = playableItems.first else { return nil }
//        guard let analyticsParams = itemToAuthorize.analyticsParams(), let itemId = analyticsParams["Item ID"] as? String, let itemTitle = itemToAuthorize.playableName() else { return nil }
//        self.playableItemId = itemId
        
        return "<rss version=\"2.0\" xmlns:media=\"http://search.yahoo.com/mrss/\"><channel><title>\(resourceID)</title><item><title></title><guid></guid></item></channel></rss>"
    }
    
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

extension MVPD {
    func toJSON() -> [String: String] {
        return ["id" : self.id ?? "",
                "title" : self.displayName ?? "",
                "logoURL" : self.logoURL ?? ""]
    }
}
extension Array where Element:MVPD {
    func toJSONObjects() -> [[String: String]] {
        return self.compactMap{$0.toJSON()}
    }
}
