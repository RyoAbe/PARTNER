//
//  Profile.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/02.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

class Profile: NSObject, NSCoding{

    dynamic var id: NSString!
    dynamic var name: NSString!
    
    // ???: profileImageに変更
    dynamic var image: UIImage!
    dynamic var isAuthenticated: Bool
    dynamic var hasPartner: Bool

    var key: NSString {
        assert(false, "overrideして下さい")
        return "Profile"
    }

    class var sharedInstance : Profile {
        assert(false, "overrideして下さい")
        return Profile()
    }

    init(id: NSString?, name: NSString?, image: UIImage?, isAuthenticated: Bool, hasPartner: Bool){
        self.id = id
        self.name = name
        self.image = image
        self.isAuthenticated = isAuthenticated
        self.hasPartner = hasPartner
    }

    convenience override init(){
        self.init(id: nil, name: nil, image: nil, isAuthenticated: false, hasPartner: false)
    }

    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObjectForKey("id") as? NSString
        self.name = aDecoder.decodeObjectForKey("name") as? NSString
        self.image = aDecoder.decodeObjectForKey("image") as? UIImage
        self.isAuthenticated = aDecoder.decodeObjectForKey("isAuthenticated") as Bool
        self.hasPartner = aDecoder.decodeObjectForKey("hasPartner") as Bool
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.id, forKey: "id")
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.image, forKey: "image")
        aCoder.encodeObject(self.isAuthenticated, forKey: "isAuthenticated")
        aCoder.encodeObject(self.hasPartner, forKey: "hasPartner")
    }

    func save() -> Profile {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let data = NSKeyedArchiver.archivedDataWithRootObject(self)
        userDefaults.setObject(data, forKey: self.key)
        userDefaults.synchronize()
        return self
    }

    class func read() -> Profile! {
        assert(false, "overrideして下さい")
        return Profile()
    }
}
