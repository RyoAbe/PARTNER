//
//  BaseViewController.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/03/29.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        FBAppEvents.logEvent("Appear - \(className)")
    }
}
