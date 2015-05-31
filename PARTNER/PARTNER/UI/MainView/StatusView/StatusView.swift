//
//  StatusView.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/02.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

enum StatusViewType {
    case MyStatus, PartnersStatus
    var namePlaceholder : String {
        switch self {
        case .MyStatus:
            return "Not yet sign in."
        case .PartnersStatus:
            return "No partner."
        }
    }
}
// ???: 既読が見れるようにする
// TODO: 起動直後「Not yet partner」が出る
class StatusView: UIView {

    @IBOutlet private weak var overlayView: UIView!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var statusIcon: UIImageView!
    @IBOutlet private weak var atLabel: UILabel!
    @IBOutlet private weak var statusNameLabel: UILabel!
    @IBOutlet private weak var profileNameLabel: UILabel!
    @IBOutlet private weak var statusIconHeight: NSLayoutConstraint!
    @IBOutlet private weak var statusIconWidth: NSLayoutConstraint!
    @IBOutlet private weak var baseView: UIView!
    @IBOutlet weak var profileIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        baseView.hidden = true
        atLabel.text = nil
        statusIcon.image = nil
        statusNameLabel.text = nil
        profileNameLabel.text = nil
        profileImageView.image = nil
    }

    var profile: Profile! {
        willSet {
            if self.profile == nil {
                return
            }
            self.profile.removeObserver(self, forKeyPath: "name")
            self.profile.removeObserver(self, forKeyPath: "image")
            self.profile.removeObserver(self, forKeyPath: "statuses")
            self.profile.removeObserver(self, forKeyPath: "isAuthenticated")
        }
        didSet {
            overlayView.hidden = profile.image == nil
            profileIcon.hidden = profile.isAuthenticated
            profileNameLabel.text = profile.isAuthenticated ? profile.name : statusViewType?.namePlaceholder
            profileImageView.image = profile.image
            let status = profile.statuses?.last
            statusType = status?.types.statusType
            statusDate = status?.date
            profile.addObserver(self, forKeyPath:"name", options: .New, context: nil)
            profile.addObserver(self, forKeyPath:"image", options: .New, context: nil)
            profile.addObserver(self, forKeyPath:"statuses", options: .New, context: nil)
            profile.addObserver(self, forKeyPath:"isAuthenticated", options: .New, context: nil)
        }
    }

    deinit{
        profile.removeObserver(self, forKeyPath: "name")
        profile.removeObserver(self, forKeyPath: "image")
        profile.removeObserver(self, forKeyPath: "statuses")
        profile.removeObserver(self, forKeyPath: "isAuthenticated")
    }

    var statusViewType: StatusViewType! {
        didSet {
            profileNameLabel.text = statusViewType.namePlaceholder
        }
    }

    private var statusType: StatusType! {
        didSet {
            if let type = statusType {
                baseView.hidden = false
                statusNameLabel.text = type.name
                statusIcon.image = UIImage(named: statusType!.iconImageName.stringByReplacingOccurrencesOfString("_icon", withString: "_large_icon"))
                overlayView.alpha = 0.6
                return
            }
            baseView.hidden = true
            statusNameLabel.text = nil
            statusIcon.image = nil
            overlayView.alpha = 0.3
        }
    }

    private var statusDate: NSDate! {
        didSet {
            if let date = statusDate {
                let fmt = NSDateFormatter()
                fmt.dateFormat = "HH:mm"
                atLabel.text = fmt.stringFromDate(date)
            }
        }
    }

    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if object as! NSObject == profile {
            profile = object as! Profile
            return
        }
        assert(false)
    }
}
