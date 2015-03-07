//
//  HistoryViewDataSource.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/03/07.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

class HistoryViewDataSource: NSObject, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HistoryCell") as HistoryCell

        let type = StatusTypes(rawValue: indexPath.row % 9)!.status()
        cell.textLabel!.text = type.name
        cell.imageView!.image = UIImage(named: type.iconImageName)
        
        let fmt = NSDateFormatter()
        fmt.dateFormat = "HH:mm";
        cell.detailTextLabel?.text = fmt.stringFromDate(NSDate())

        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 18
    }
}
