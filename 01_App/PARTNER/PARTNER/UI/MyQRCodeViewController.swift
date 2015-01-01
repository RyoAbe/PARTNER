//
//  MyQRCodeViewController.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/11/30.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

class MyQRCodeViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0, alpha: 0.8);
    }

    @IBAction func didTapCloseButton(sender: AnyObject) {
        self .dismissViewControllerAnimated(true, completion: nil)
    }
}
