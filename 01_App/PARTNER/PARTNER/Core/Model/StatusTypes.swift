//
//  StatusTypes.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/01/24.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

class StatusTypes: NSArray {
//    convenience override init() {
//        self.init(array: [
//            StatusType(id: 1, iconImageName: "good_morning", name: "Good morning."),
//            StatusType(id: 2, iconImageName: "going_home", name: "I’m going home."),
//            StatusType(id: 3, iconImageName: "left_home", name: "I left home."),
//            StatusType(id: 4, iconImageName: "have_dinner", name: "I have dinner."),
//            StatusType(id: 5, iconImageName: "there", name: "I’m almost there."),
//            StatusType(id: 6, iconImageName: "god_it", name: "Got it."),
//            StatusType(id: 7, iconImageName: "good_night", name: "Good night."),
//            StatusType(id: 8, iconImageName: "location", name: "Location"),
//            StatusType(id: 9, iconImageName: "love", name: "I Love you.")
//        ])
//    }
    override init() { super.init() }
    override init(objects: UnsafePointer<AnyObject?>, count cnt: Int) { super.init(objects: objects, count: cnt) }
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
//    required override init(capacity numItems: Int) { super.init(capacity: numItems) }
}
