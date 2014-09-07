//
//  AddPartnerViewController.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/07.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

class AddPartnerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func useLocation(sender: UIButton) {

        var query = PFQuery(className:PFUser.parseClassName())
        query.getObjectInBackgroundWithId("CXqhnscxHF") {
            (user: PFObject!, error: NSError!) -> Void in
            if (error == nil) {
                NSLog("%@", user)
                UpdateUserOperation(partner: user).save()
            } else {
                NSLog("%@", error)
            }
        }
    }

    @IBAction func done(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion:nil)
    }
}
