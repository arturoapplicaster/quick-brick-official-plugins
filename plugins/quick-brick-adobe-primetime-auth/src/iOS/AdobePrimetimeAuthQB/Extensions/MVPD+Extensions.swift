//
//  MVPD+Extensions.swift
//  AdobeAccessEnablerQB
//
//  Created by brel on 3/24/20.
//

import Foundation
import AccessEnabler

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
