//
//  Statuses.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/03/11.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import Foundation

class Statuses {
    var statuses: Array<PFObject>
    
    var numberOfSections: NSInteger {
        return 1
    }
    var numberOfRows: NSInteger {
        return statuses.count
    }

    init(pfUser: PFUser){
        statuses = []
        for pfStatusPointer in pfUser["statuses"] as NSArray {
            let pfStatus = PFQuery.getObjectOfClass("Status", objectId: pfStatusPointer.objectId)
            statuses.append(pfStatus)
        }
    }
    
    func objectAtRow(row: NSInteger) -> Status? {
        let pfStatus = statuses[row]
        let type = (pfStatus["type"] as NSNumber).integerValue
        return Status(types: StatusTypes(rawValue: type)!, date: pfStatus.createdAt as NSDate)
    }
}