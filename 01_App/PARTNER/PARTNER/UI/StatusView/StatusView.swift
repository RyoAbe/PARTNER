//
//  StatusView.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/02.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

class StatusView: UIView {

    // ???: 【CoreData > KVO】モデルをObserveして状態が更新されたらView側をstatusアイコンと日付を更新する
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var atLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    var profile: Profile! {
        willSet{
            if(self.profile == nil){
                return
            }
            self.profile.removeObserver(self, forKeyPath: "name")
            self.profile.removeObserver(self, forKeyPath: "image")
        }
        didSet{
            self.nameLabel.text = profile.name;
            self.profileImageView.image = profile.image
            profile.addObserver(self, forKeyPath:"name", options: NSKeyValueObservingOptions.New, context: nil)
            profile.addObserver(self, forKeyPath:"image", options: NSKeyValueObservingOptions.New, context: nil)
        }
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if(object as? NSObject == self.profile && keyPath == "name"){
            self.nameLabel.text = self.profile.name;
            return
        }
        if(object as? NSObject == self.profile && keyPath == "image"){
            self.profileImageView.image = self.profile.image;
            return
        }
        super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
    }
}
