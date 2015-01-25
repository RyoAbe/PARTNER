//
//  StatusView.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/02.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

class StatusView: UIView {

    // ???: 空の人型アイコンと「no partner」を入れる
    // TODO: 状態が更新されたらその状態のアイコンを入れる。日付も入れる
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
                profileNameLabel.textColor = UIColor(white: 0.7, alpha: 1)
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
            statusIcon.image = UIImage(named: statusType.iconImageName)
        }
    }

    var date: NSDate! {
        didSet {
            baseView.hidden = false
            let fmt = NSDateFormatter()
            fmt.dateFormat = "HH:mm";
            atLabel.text = fmt.stringFromDate(date)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        layer.borderColor = UIColor(white: 0.7, alpha: 1).CGColor
        layer.borderWidth = 0.5
        
        statusIcon.tintColor = UIColor.whiteColor()

        baseView.layer.borderColor = UIColor.whiteColor().CGColor
        baseView.layer.borderWidth = 0.5
        baseView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        baseView.hidden = true

        atLabel.text = nil
        statusIcon.image = nil
        statusNameLabel.text = nil
    }

    override func updateConstraints() {
        super.updateConstraints()
        let iconSize = CGFloat(40)
        statusIconHeight.constant = iconSize
        statusIconWidth.constant = iconSize
        baseView.layer.cornerRadius = baseView.frame.width * 0.5
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
