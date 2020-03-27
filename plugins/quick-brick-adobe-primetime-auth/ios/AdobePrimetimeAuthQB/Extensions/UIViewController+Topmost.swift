//
//  UIViewController+Topmost.swift
//  AdobeAccessEnablerQB
//
//  Created by brel on 3/24/20.
//

import UIKit

extension UIViewController {
    
    class func instantiateVC() -> Self {
        return initFromStoryboard()
    }
    
    private class func initFromStoryboard<T>() -> T {
        let bundle = Bundle(for: T.self as! AnyClass) // swiftlint:disable:this force_cast
        let storyboard = UIStoryboard(name: String(describing: T.self), bundle: bundle)
        return storyboard.instantiateViewController(withIdentifier: String(describing: T.self)) as! T
        // swiftlint:disable:previous force_cast
    }
    
    class func topmostViewController() -> UIViewController? {
        guard let window = UIApplication.shared.delegate?.window ,
            let rootViewController = window?.rootViewController else {
            return nil
        }
        
        var top: UIViewController = rootViewController
        while let newTop = top.presentedViewController {
            top = newTop
        }
        
        return top
    }
}
