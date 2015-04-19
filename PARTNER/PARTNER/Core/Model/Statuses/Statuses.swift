//
//  Statuses.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/03/11.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import Foundation

class Statuses: NSObject {
    var statuses: Array<Status> = []
    var numberOfSections: NSInteger { return 1 }
    var numberOfRows: NSInteger { return statuses.count }

    convenience init (mixStatuses: Array<Status>){
        self.init()
        statuses = mixStatuses
    }

    func objectAtRow(row: NSInteger) -> Status? {
        return statuses[row]
    }
}