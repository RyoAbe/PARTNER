//
//  GetUserOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/01/01.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

class GetUserOperation: BaseOperation {
    
    var objectId: NSString!
    var result: PFUser?

    init(objectId : NSString){
        super.init()
        self.objectId = objectId
    }

    override func main() {
        super.main()
        PFUser.query().getObjectInBackgroundWithId(self.objectId, block: { object, error in
            if object == nil  {
                self.finished = true
                return;
            }
            if let hasPartner = object.objectForKey("hasPartner") as? Bool {
                if !hasPartner {
                    self.result = object as? PFUser
                }
            }
            self.finished = true
        })

    }
}
