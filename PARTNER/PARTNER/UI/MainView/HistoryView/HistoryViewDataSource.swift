//
//  HistoryViewDataSource.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/03/07.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

protocol HistoryViewDataSourceDelegate {
    func didChangeDataSource(dataSource: HistoryViewDataSource)
}

class HistoryViewDataSource: NSObject, UITableViewDataSource {
    var margedStatuses: Statuses
    let myProfile: MyProfile
    let partner: Partner
    var delegate: HistoryViewDataSourceDelegate?

    override init() {
        myProfile = MyProfile.read() as! MyProfile
        partner = Partner.read() as! Partner
        margedStatuses = Statuses(mixStatuses: (myProfile.statuses! + partner.statuses!).sorted{ $0.date.compare($1.date) == NSComparisonResult.OrderedAscending })
//        margedStatuses = Statuses(mixStatuses: (partner.statuses!).sorted{ $0.date.compare($1.date) == NSComparisonResult.OrderedAscending })

        super.init()
        myProfile.addObserver(self, forKeyPath:"statuses", options: .New, context: nil)
        partner.addObserver(self, forKeyPath:"statuses", options: .New, context: nil)
    }
    
    convenience init(delegate: HistoryViewDataSourceDelegate) {
        self.init()
        self.delegate = delegate
    }

    deinit {
        myProfile.removeObserver(self, forKeyPath: "statuses")
        partner.removeObserver(self, forKeyPath: "statuses")
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

    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if object as! NSObject == myProfile || object as! NSObject == partner {
            if margedStatuses.statuses.count != (myProfile.statuses!.count + partner.statuses!.count) {
                margedStatuses = Statuses(mixStatuses: (myProfile.statuses! + partner.statuses!).sorted{ $0.date.compare($1.date) == NSComparisonResult.OrderedAscending })
                delegate?.didChangeDataSource(self)
            }
            return
        }
        assert(false)
    }
}
