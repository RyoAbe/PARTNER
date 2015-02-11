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
    dynamic var image: UIImage!
    dynamic var isAuthenticated: Bool
    dynamic var hasPartner: Bool
    // ???: 本当はenumだけでよい
    dynamic var statusType: StatusType?
    dynamic var statusDate: NSDate?

    class var key : NSString {
        assert(false, "overrideして下さい")
        return "Profile"
    }
    
    class var sharedInstance : Profile {
        assert(false, "overrideして下さい")
        return Profile()
    }
    
    init(id: NSString?, name: NSString?, image: UIImage?, isAuthenticated: Bool, hasPartner: Bool, statusType: StatusType?, statusDate: NSDate?) {
        self.id = id
        self.name = name
        self.image = image
        self.isAuthenticated = isAuthenticated
        self.hasPartner = hasPartner
        self.statusType = statusType
        self.statusDate = statusDate
    }

    convenience override init(){
        self.init(id: nil, name: nil, image: nil, isAuthenticated: false, hasPartner: false, statusType: nil, statusDate: nil)
    }

    required init(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObjectForKey("id") as? NSString
        name = aDecoder.decodeObjectForKey("name") as? NSString
        image = aDecoder.decodeObjectForKey("image") as? UIImage
        isAuthenticated = aDecoder.decodeObjectForKey("isAuthenticated") as Bool
        hasPartner = aDecoder.decodeObjectForKey("hasPartner") as Bool
        statusType = aDecoder.decodeObjectForKey("statusType") as StatusType?
        statusDate = aDecoder.decodeObjectForKey("statusDate") as NSDate?
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.id, forKey: "id")
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.image, forKey: "image")
        aCoder.encodeObject(self.isAuthenticated, forKey: "isAuthenticated")
        aCoder.encodeObject(self.hasPartner, forKey: "hasPartner")
        aCoder.encodeObject(self.statusType, forKey: "statusType")
        aCoder.encodeObject(self.statusDate, forKey: "statusDate")
    }

    func save() -> Profile {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let data = NSKeyedArchiver.archivedDataWithRootObject(self)
        userDefaults.setObject(data, forKey: self.dynamicType.key)
        userDefaults.synchronize()
        return self
    }

    class func read() -> Profile! {
        if let data = NSUserDefaults.standardUserDefaults().dataForKey(self.key) {
            return createWithData(data)
        }
        return self.sharedInstance.save()
    }
    
    class func createWithData(data: NSData) -> Profile! {
        let instance = self.sharedInstance

        let unarchivedProfile = NSKeyedUnarchiver.unarchiveObjectWithData(data) as Profile
        instance.isAuthenticated = unarchivedProfile.isAuthenticated
        instance.hasPartner = unarchivedProfile.hasPartner
        
        if unarchivedProfile.id != nil {
            instance.id = unarchivedProfile.id
        }
        if unarchivedProfile.name != nil {
            instance.name = unarchivedProfile.name
        }
        if unarchivedProfile.image != nil {
            instance.image = unarchivedProfile.image
        }
        if unarchivedProfile.statusType != nil {
            instance.statusType = unarchivedProfile.statusType
        }
        if unarchivedProfile.statusDate != nil {
            instance.statusDate = unarchivedProfile.statusDate
        }
        return instance
    }
}
