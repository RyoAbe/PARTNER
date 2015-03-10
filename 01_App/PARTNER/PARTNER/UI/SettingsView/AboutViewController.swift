//
//  AboutViewController.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/03/07.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

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

class AboutViewController: UITableViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        AboutRows(rawValue: indexPath.row)!.selected()
    }
}