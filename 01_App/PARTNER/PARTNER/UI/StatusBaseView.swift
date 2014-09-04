//
//  StatusBaseView.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/01.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

// FIXME: 本当はいらないはず
public class StatusBaseView: UIView {

    var statusView: StatusView!;
    var profile: Profile!{
        didSet{
            self.statusView.profile = profile
        }
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.statusView = NSBundle.mainBundle().loadNibNamed("StatusView", owner: nil, options: nil)[0] as StatusView;
        self.statusView.frame = self.bounds
        self.addSubview(self.statusView)
    }
}
