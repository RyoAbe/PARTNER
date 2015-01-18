//
//  GetUserOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/01/01.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

class GetUserOperation: BaseOperation {
    
    var id: NSString!
    var result: PFUser?

    init(id : NSString){
        super.init()
        self.id = id
    }

    override func main() {        
        let query = PFUser.query()
        query.whereKey("objectId", equalTo: self.id)
        query.getFirstObjectInBackgroundWithBlock { object, error in
            if !object.isKindOfClass(PFUser) {
                self.finished = true
                return;
            }
            // ???: すでにパートナーがいたらエラー

            if let hasPartner = object.objectForKey("hasPartner") as? Bool {
                if !hasPartner {
                    self.result = object as? PFUser
                }
            }
            self.finished = true
        }
    }
}
