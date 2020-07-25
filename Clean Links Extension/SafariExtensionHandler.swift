//
//  SafariExtensionHandler.swift
//  Clean Links Extension
//
//  Created by Radoslav Vitanov on 13.03.20.
//  Copyright © 2020 Radoslav Vitanov. All rights reserved.
//

import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {
    
    /**
     * This is a list of all query parameters we want to escape.
     */
    var blacklist: [String] = [
        "fbclid",
        "utm_source",
        "utm_medium",
        "utm_campaign",
        "utm_term",
        "utm_content",
        "gclid",
        "gclsrc",
        "dclid",
        "zanpid",
        "msclkid",
        "mc_eid",
        "_openstat",
        "_hsmi",
        "_hsenc"
    ]
    
    /**
     * This is a helper variable, to workaround the problem when the user opens a new link while holding CMD.
     * Because we are redirecting the page's active tab to the url, both parent and child pages will trigger this.
     *
     * We are setting this to "true" via message from the DOM when the user presses the modifier key. Later on
     * during the check, if the modifier key was pressed we just don't redirect on the first call (which is the current
     * page), but we do for the next one which should be the page that was just opened.
     */
    static var willOpenNewTab: Bool = false
    
    static var events: [Event] = [];
    
    /**
     * Handle messages coming from the DOM
     */
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        if (messageName == "keypress") {
            SafariExtensionHandler.willOpenNewTab = userInfo!["new-tab"] as! Bool;
        }
        
        if (messageName == "prevented-redirect") {
            let domain = userInfo!["domain"] as! String
            let url = userInfo!["url"] as! String
            
            SafariExtensionHandler.events.insert(
                Event(type: EventType.linkTracker, domain: domain, value: url),
            at: 0)
        }
    }
    
    override func toolbarItemClicked(in window: SFSafariWindow) {
        
    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
        let badge = SafariExtensionHandler.events.count > 0 ? String(SafariExtensionHandler.events.count) : ""
        
        validationHandler(true, "\(badge)")
    }
    
    override func popoverViewController() -> SFSafariExtensionViewController {
        return SafariExtensionViewController.shared
    }
    
    override func popoverWillShow(in window: SFSafariWindow) {
        SafariExtensionViewController.shared.items = SafariExtensionHandler.events
    }
    
    override func page(_ page: SFSafariPage, willNavigateTo url: URL?) {
        // This is a workround when the user opens a link while holding CMD.
        // If this is the case then this method is called twice, once for the
        // parent page and once for the child. In this case we don't want to
        // redirect the parent page, as you will end up with two tabs with same
        // page opened.
        if (SafariExtensionHandler.willOpenNewTab) {
            SafariExtensionHandler.willOpenNewTab = false
            return;
        }
        
        // If we don't have access to that url, just skip
        guard let url = url else {
            return
        }
        
        // Parse url components
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return
        }
        
        let linkGuard = ExternalLinkGuard(components: components)
        
        if let link = linkGuard.cleanUrl() {
            let parsedLink = URLComponents(string: link)!
            SafariExtensionHandler.events.insert(Event(type: EventType.linkTracker, domain: components.host!, value: parsedLink.host!
            ), at: 0)
            
            page.getContainingTab(completionHandler: {
                $0.navigate(to: URL(string: link)!)
            })
            return
        }
        
        // Parse the query parameters, if there are any
        if let queryItems = components.queryItems {
            // Filter out the blacklisted params
            components.queryItems = queryItems.filter({
                let isBlacklisted = blacklist.contains($0.name) || $0.name.starts(with: "utm_");
                
                if (isBlacklisted) {
                    SafariExtensionHandler.events.insert(Event(type: EventType.parameter, domain: components.host!, value: $0.name
                    ), at: 0)
                }
                
                return !isBlacklisted
            })
            
            // If there are no query parameters remove the query "?" sign
            if (components.queryItems?.count == 0) {
                components.query = nil
            }
            
            // If we haven't removed anything, e.g. no bad params were present
            // in the url, do nothing
            if (components.queryItems?.count == queryItems.count) {
                return
            }
            
            // Do the actual redirect to the clean url
            if let redirect = components.url {
                page.getContainingTab(completionHandler: {
                    $0.navigate(to: redirect)
                })
            }
                
        }
        
    }

}
