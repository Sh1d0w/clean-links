//
//  DataStructures.swift
//  Clean Links Extension
//
//  Created by Radoslav Vitanov on 14.03.20.
//  Copyright © 2020 Radoslav Vitanov. All rights reserved.
//

import Foundation

enum EventType {
    case parameter
    case linkTracker
}

struct Event {
    let type: EventType
    let domain: String
    let value: String
}
