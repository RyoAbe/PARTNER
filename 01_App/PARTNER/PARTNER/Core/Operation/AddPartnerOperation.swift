//
//  AddPartnerOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/01/01.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

class AddPartnerOperation: BaseOperation {

    var user: PFUser!
    
    init(user: PFUser){
        self.user = user
        super.init()
    }

    override func main() {
    }
}
