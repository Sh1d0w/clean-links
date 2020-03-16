//
//  ExternalLinkGuard.swift
//  Clean Links Extension
//
//  Created by Radoslav Vitanov on 15.03.20.
//  Copyright © 2020 Radoslav Vitanov. All rights reserved.
//

import Foundation

class ExternalLinkGuard {
    var components: URLComponents
    
    init(components: URLComponents) {
        self.components = components
    }
    
    func cleanUrl() -> String? {
        if isGoogleTrackingUrl() {
            return removeGoogleRedirect()
        }
        
        if isFacebookTrackingUrl() {
            return removeFacebookRedirect()
        }
        
        return nil
    }
    
    func isGoogleTrackingUrl() -> Bool {
        if (components.host!.contains("google") && components.path == "/url") {
            return true
        }
        
        return false
    }
    
    func isFacebookTrackingUrl() -> Bool {
        if (components.host! == "l.facebook.com") {
            return true
        }
        
        return false
    }
    
    func removeGoogleRedirect() -> String {
        if components.query == nil {
            return components.string!
        }
        
        let urlParam = components.queryItems?.first(where: { (item) -> Bool in
            return item.name == "url" || item.name == "q"
        })
        
        if let url = urlParam?.value {
            return url
        }
        
        return components.string!
    }
    
    func removeFacebookRedirect() -> String {
        if components.query == nil {
            return components.string!
        }
        
        let urlParam = components.queryItems?.first(where: { (item) -> Bool in
            item.name == "u"
        })
        
        if let url = urlParam?.value {
            return url
        }
        
        return components.string!
    }
}
