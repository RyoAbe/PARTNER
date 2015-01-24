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
        if(object as NSObject == profile && keyPath == "name"){
            nameLabel.text = profile.name;
            return
        }
        if(object as? NSObject == profile && keyPath == "image"){
            profileImageView.image = profile.image;
            return
        }
        super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
    }
}
