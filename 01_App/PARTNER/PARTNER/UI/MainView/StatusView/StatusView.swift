//
//  StatusView.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/02.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

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

    var profile: Profile! {
        willSet{
            if(self.profile == nil){
                return
            }
            self.profile.removeObserver(self, forKeyPath: "name")
            self.profile.removeObserver(self, forKeyPath: "image")
            self.profile.removeObserver(self, forKeyPath: "statusType")
            self.profile.removeObserver(self, forKeyPath: "statusDate")
        }
        didSet{
            profileNameLabel.text = profile.name
            if profile.name == nil {
                profileNameLabel.text = "Partnerless"
            }
            profileImageView.image = profile.image
            if let type = profile.statusType {
                statusType = type
            }
            if let d = profile.statusDate {
                date = d
            }
            profile.addObserver(self, forKeyPath:"name", options: NSKeyValueObservingOptions.New, context: nil)
            profile.addObserver(self, forKeyPath:"image", options: NSKeyValueObservingOptions.New, context: nil)
            profile.addObserver(self, forKeyPath:"statusType", options: NSKeyValueObservingOptions.New, context: nil)
            profile.addObserver(self, forKeyPath:"statusDate", options: NSKeyValueObservingOptions.New, context: nil)
        }
    }

    var statusType: StatusType! {
        didSet {
            baseView.hidden = false
            statusNameLabel.text = statusType.name?
            let name = statusType.iconImageName.stringByReplacingOccurrencesOfString("_icon", withString: "_large_icon")
            statusIcon.image = UIImage(named: name)
        }
    }

    var date: NSDate! {
        didSet {
            let fmt = NSDateFormatter()
            fmt.dateFormat = "HH:mm";
            atLabel.text = fmt.stringFromDate(date)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        atLabel.text = nil
        statusIcon.image = nil
        statusNameLabel.text = nil
        profileImageView.image = nil
    }

    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if(object as NSObject == profile && keyPath == "name"){
            profileNameLabel.text = profile.name
            return
        }
        if(object as? NSObject == profile && keyPath == "image"){
            profileImageView.image = profile.image
            return
        }
        if(object as? NSObject == profile && keyPath == "statusType"){
            statusType = profile.statusType
            return
        }
        if(object as? NSObject == profile && keyPath == "statusDate"){
            date = profile.statusDate
            return
        }
        super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
    }
}
