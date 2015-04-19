//
//  AboutViewController.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/03/07.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

class AboutViewController: UITableViewController {
    @IBOutlet weak var versionLabel: UILabel!
    enum AboutRows : NSInteger {
        case AboutDeveloper = 0
        case License
        func selected() {
            switch self {
            case .AboutDeveloper:
                UIApplication.sharedApplication().openURL(NSURL(string: "http://ryoabe.com/")!)
                return
            case .License:
                return
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let bundleVersion = NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as! String
        versionLabel.text = "ver \(bundleVersion)"
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        AboutRows(rawValue: indexPath.row)!.selected()
    }
}
