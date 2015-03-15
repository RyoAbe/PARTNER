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
        statuses = DummyStatuses()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return statuses.numberOfSections
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses.numberOfRows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        let currentStatus = statuses.objectAtRow(row) as Status!

        let cell = currentStatus is MyStatus ? tableView.dequeueReusableCellWithIdentifier("MyHistoryCell") as MyHistoryCell
                                             : tableView.dequeueReusableCellWithIdentifier("PartnersHistoryCell") as PartnersHistoryCell
        cell.currentStatus = currentStatus
        cell.prevStatus = row == 0 ? nil : statuses.objectAtRow(row - 1) as Status!
        cell.nextStatus = row + 1 == statuses.numberOfRows ? nil : statuses.objectAtRow(row + 1) as Status!
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false

        return cell
    }
}
