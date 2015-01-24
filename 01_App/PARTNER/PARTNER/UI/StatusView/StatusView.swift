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

    var profile: Profile! {
        willSet{
            if(self.profile == nil){
                return
            }
            self.profile.removeObserver(self, forKeyPath: "name")
            self.profile.removeObserver(self, forKeyPath: "image")
        }
        didSet{
            profileNameLabel.text = profile.name
            profileImageView.image = profile.image
            profile.addObserver(self, forKeyPath:"name", options: NSKeyValueObservingOptions.New, context: nil)
            profile.addObserver(self, forKeyPath:"image", options: NSKeyValueObservingOptions.New, context: nil)
        }
    }
    var statusType: StatusType! {
        didSet {
            statusNameLabel.text = statusType.name
            statusIcon.image = UIImage(named: statusType.iconImageName)
        }
    }

    var date: NSDate! {
        didSet {
            let fmt = NSDateFormatter()
            fmt.dateStyle = NSDateFormatterStyle.ShortStyle
            fmt.timeStyle = NSDateFormatterStyle.ShortStyle
            atLabel.text = fmt.stringFromDate(date)
        }
    }

    override func updateConstraints() {
        super.updateConstraints()
        let iconSize = self.frame.width * 0.4
        statusIconHeight.constant = iconSize
        statusIconWidth.constant = iconSize
    }
    
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if(object as NSObject == profile && keyPath == "name"){
            profileNameLabel.text = profile.name;
            return
        }
        if(object as? NSObject == profile && keyPath == "image"){
            profileImageView.image = profile.image;
            return
        }
        super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
    }
}
