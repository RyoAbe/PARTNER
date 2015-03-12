//
//  HistoryViewDataSource.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/03/07.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

class HistoryViewDataSource: NSObject, UITableViewDataSource {
    let statuses: Statuses!
    override init() {
        super.init()
        // TODO: 外から渡せるように
//        statuses = MyStatuses()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HistoryCell") as HistoryCell

        let type = StatusTypes(rawValue: indexPath.row % 9)!.statusType
        cell.textLabel!.text = type.name
        cell.imageView!.image = UIImage(named: type.iconImageName)

        let fmt = NSDateFormatter()
        fmt.dateFormat = "MM/dd HH:mm";
        cell.detailTextLabel?.text = fmt.stringFromDate(NSDate())

        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 18
    }

//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return statuses.numberOfSections
//    }
//
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return statuses.numberOfRows
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("HistoryCell") as HistoryCell
//        
//        let status = statuses.objectAtRow(indexPath.row) as Status!
//        cell.textLabel!.text = status.type.name
//        cell.imageView!.image = UIImage(named: status.type.iconImageName)
//
//        let fmt = NSDateFormatter()
//        fmt.dateFormat = "HH:mm"
//        cell.detailTextLabel?.text = fmt.stringFromDate(status.date)
//
//        return cell
//    }
}
