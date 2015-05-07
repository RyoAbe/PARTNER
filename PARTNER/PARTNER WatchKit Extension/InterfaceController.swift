//
//  InterfaceController.swift
//  PARTNER WatchKit Extension
//
//  Created by RyoAbe on 2015/05/04.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {

    @IBOutlet weak var tableView: WKInterfaceTable!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        tableView.setNumberOfRows(NumberOfTotalStatusMenu, withRowType: "Cell")
        for i in 0...(NumberOfTotalStatusMenu - 1) {
            let row = tableView.rowControllerAtIndex(i) as! StatusMenu
            let type = StatusTypes(rawValue: i)!.statusType
            row.textLabel.setText(type.name)
            row.imageView.setImage(UIImage(named: type.iconImageName))
        }
    }
}
