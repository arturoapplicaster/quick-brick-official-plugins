//
//  FirebaseInAppMessageUniversalLinks.swift
//  ZappiOS
//
//  Created by brel on 4/10/20.
//  Copyright © 2020 Applicaster Ltd. All rights reserved.
//

import Foundation
import ZappCore

public class FirebaseInAppMessageUniversalLinks: NSObject, AppLoadingHookProtocol, GeneralProviderProtocol {
    
    public required init(pluginModel: ZPPluginModel) {
        model = pluginModel
    }
    
    public var model: ZPPluginModel?
    
    public var providerName: String = "FirebaseInAppMessageUniversalLinks"
    
    public func prepareProvider(_ defaultParams: [String : Any], completion: ((Bool) -> Void)?) {
        completion?(true)
    }
    
    public func disable(completion: ((Bool) -> Void)?) {
        completion?(true)
    }
    
    public func executeOnContinuingUserActivity(_ userActivity: NSUserActivity?, completion: (() -> Void)?) {
        guard let URL = userActivity?.webpageURL, UIApplication.shared.canOpenURL(URL) else {
            completion?()
            return
        }
        UIApplication.shared.open(URL)
        completion?()
    }
    
}
