//
//  SafariExtensionViewController.swift
//  Clean Links Extension
//
//  Created by Radoslav Vitanov on 13.03.20.
//  Copyright © 2020 Radoslav Vitanov. All rights reserved.
//

import SafariServices

class SafariExtensionViewController: SFSafariExtensionViewController {
    
    static let shared: SafariExtensionViewController = {
        let shared = SafariExtensionViewController()
        shared.preferredContentSize = NSSize(width:320, height:240)
        return shared
    }()

}
