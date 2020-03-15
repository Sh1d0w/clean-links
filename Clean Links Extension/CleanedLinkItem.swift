//
//  CleanedLinkItem.swift
//  Clean Links Extension
//
//  Created by Radoslav Vitanov on 14.03.20.
//  Copyright © 2020 Radoslav Vitanov. All rights reserved.
//

import Cocoa

class CleanedLinkItem: NSCollectionViewItem {
    
    @IBOutlet weak var label: NSTextField!
    
    @IBOutlet weak var image: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.isEditable = false
        label.allowsEditingTextAttributes = true
    }
    
}
