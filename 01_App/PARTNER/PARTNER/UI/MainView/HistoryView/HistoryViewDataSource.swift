//
//  HistoryViewDataSource.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/03/07.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

class HistoryViewDataSource: NSObject, UITableViewDataSource {
    let margedStatuses: Statuses!
    override init() {
        margedStatuses = Statuses()
        var statuses = MyProfile.read().statuses! + Partner.read().statuses!
        statuses.sort{ $0.date.compare($1.date) == NSComparisonResult.OrderedAscending }
        margedStatuses.statuses = statuses
        super.init()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return margedStatuses.numberOfSections
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return margedStatuses.numberOfRows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        let currentStatus = margedStatuses.objectAtRow(row) as Status!

        let cell = currentStatus is MyStatus ? tableView.dequeueReusableCellWithIdentifier("MyHistoryCell") as! MyHistoryCell
                                             : tableView.dequeueReusableCellWithIdentifier("PartnersHistoryCell") as! PartnersHistoryCell
        cell.currentStatus = currentStatus
        cell.prevStatus = row == 0 ? nil : margedStatuses.objectAtRow(row - 1) as Status!
        cell.nextStatus = row + 1 == margedStatuses.numberOfRows ? nil : margedStatuses.objectAtRow(row + 1) as Status!
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false

        return cell
    }
}
