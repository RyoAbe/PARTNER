//
//  StatusBaseView.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/01.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

// ???: 【次にやる！！！】本当は本Viewはいらないはず
public class StatusBaseView: UIView {

    var statusView: StatusView!
    var profile: Profile! {
        didSet {
            self.statusView.profile = profile
        }
    }
    var statusType: StatusType! {
        didSet {
            self.statusView.statusType = statusType
        }
    }
    var date: NSDate! {
        didSet {
            self.statusView.date = date
        }
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.statusView = NSBundle.mainBundle().loadNibNamed("StatusView", owner: nil, options: nil)[0] as StatusView;
        self.statusView.frame = self.bounds
        self.addSubview(self.statusView)
    }
}
