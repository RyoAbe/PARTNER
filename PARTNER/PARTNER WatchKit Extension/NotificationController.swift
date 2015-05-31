//
//  NotificationController.swift
//  PARTNER WatchKit Extension
//
//  Created by RyoAbe on 2015/05/04.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import WatchKit
import Foundation


class NotificationController: WKUserNotificationInterfaceController {
    @IBOutlet weak var dateLabel: WKInterfaceLabel!
    @IBOutlet weak var imageView: WKInterfaceImage!
    @IBOutlet weak var label: WKInterfaceLabel!

    override func didReceiveRemoteNotification(remoteNotification: [NSObject : AnyObject], withCompletion completionHandler: ((WKUserNotificationInterfaceType) -> Void)) {
        
        Logger.debug("remoteNotification:\(remoteNotification)")

        if let dic = remoteNotification["aps"] as? [NSObject:AnyObject] {
            if let alert = dic["alert"] as? String {
                label.setText(alert)
            }
        }
        // ???: 必要ならLargeに変更
        if let rawValueTypes = remoteNotification["type"] as? Int {
            let types = StatusTypes(rawValue: rawValueTypes)!
            imageView.setImage(UIImage(named: types.statusType.iconImageName))
        }
        if let dateString = remoteNotification["date"] as? String {
            let date = NSDate(timeIntervalSince1970: atof(dateString))
            let fmt = NSDateFormatter()
            fmt.dateFormat = "YYYY/MM/dd HH:mm"
            dateLabel.setText(fmt.stringFromDate(date))
        }
        completionHandler(.Custom)
    }
}
