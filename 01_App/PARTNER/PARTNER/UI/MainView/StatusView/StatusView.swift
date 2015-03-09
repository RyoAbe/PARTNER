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
    var nameLabelPlaceholder : NSString {
        switch self {
        case .MyStatus:
            return "Not yet sign in"
        case .PartnersStatus:
            return "No partner"
        }
    }
}

class StatusView: UIView {

    // TODO: 空の人型アイコンと「no partner」を入れる
    // ???: もうちょいかっこよく書けるはず
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
            self.profile.removeObserver(self, forKeyPath: "statusType")
            self.profile.removeObserver(self, forKeyPath: "statusDate")
            self.profile.removeObserver(self, forKeyPath: "isAuthenticated")
        }
        didSet {
            profileIcon.hidden = profile.isAuthenticated
            profileNameLabel.text = profile.name
            profileImageView.image = profile.image
            statusType = profile.statusType
            statusDate = profile.statusDate
            profile.addObserver(self, forKeyPath:"name", options: NSKeyValueObservingOptions.New, context: nil)
            profile.addObserver(self, forKeyPath:"image", options: NSKeyValueObservingOptions.New, context: nil)
            profile.addObserver(self, forKeyPath:"statusType", options: NSKeyValueObservingOptions.New, context: nil)
            profile.addObserver(self, forKeyPath:"statusDate", options: NSKeyValueObservingOptions.New, context: nil)
            profile.addObserver(self, forKeyPath:"isAuthenticated", options: NSKeyValueObservingOptions.New, context: nil)
        }
    }

    var statusViewType: StatusViewType! {
        didSet {
            profileNameLabel.text = statusViewType.nameLabelPlaceholder
        }
    }

    private var statusType: StatusType? {
        didSet {
            if let type = statusType {
                baseView.hidden = false
                statusNameLabel.text = type.name
                statusIcon.image = UIImage(named: statusType!.iconImageName.stringByReplacingOccurrencesOfString("_icon", withString: "_large_icon"))
            }
        }
    }

    private var statusDate: NSDate? {
        didSet {
            if let date = statusDate {
                let fmt = NSDateFormatter()
                fmt.dateFormat = "HH:mm"
                atLabel.text = fmt.stringFromDate(date)
            }
        }
    }

    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if object as NSObject == profile {
            profile = object as Profile
            return
        }
        super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
    }
}
