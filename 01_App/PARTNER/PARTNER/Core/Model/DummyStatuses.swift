//
//  DummyStatuses.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/03/15.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import Foundation

class DummyStatuses: Statuses {
    var dummyStatuses: Array<Status>

    override var numberOfRows: NSInteger {
        return dummyStatuses.count
    }
    
    override init(){
        dummyStatuses = []
        super.init()
        for i in 0...100 {
            let date = NSDate()
            let type = Int(arc4random_uniform(9))
            let status = arc4random_uniform(2) == 0 ? MyStatus(types: StatusTypes(rawValue: type)!, date: date)
                                                    : PartnersStatus(types: StatusTypes(rawValue: type)!, date: date)
            dummyStatuses.append(status)
        }
    }

    override func objectAtRow(row: NSInteger) -> Status? {
        return dummyStatuses[row]
    }
}