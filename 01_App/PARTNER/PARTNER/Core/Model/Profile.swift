//
//  Profile.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/02.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

class Profile: NSObject, NSCoding{

    // ???: fbId持たせてもいいかもね
    dynamic var id: NSString!
    dynamic var name: NSString!
    dynamic var image: UIImage!
    // ???: nameとisAuthenticatedはPFUserから持ってくれば良い。またisAuthenticatedはMyProgileのみが持てば良い
    dynamic var isAuthenticated: Bool
    dynamic var hasPartner: Bool
    // ???: いらなくなる
    dynamic var statusType: StatusType?
    dynamic var statusDate: NSDate?
    dynamic var statuses: Array<Status>

    class var key : NSString {
        assert(false, "overrideして下さい")
        return "Profile"
    }
    
    class var sharedInstance : Profile {
        assert(false, "overrideして下さい")
        return Profile()
    }

    init(id: NSString?, name: NSString?, image: UIImage?, isAuthenticated: Bool, hasPartner: Bool, statusType: StatusType?, statusDate: NSDate?, statuses: Array<Status>) {
        self.id = id
        self.name = name
        self.image = image
        self.isAuthenticated = isAuthenticated
        self.hasPartner = hasPartner
        self.statusType = statusType
        self.statusDate = statusDate
        self.statuses = statuses
    }

    convenience override init(){
        self.init(id: nil, name: nil, image: nil, isAuthenticated: false, hasPartner: false, statusType: nil, statusDate: nil, statuses: [])
    }

    required init(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObjectForKey("id") as? NSString
        name = aDecoder.decodeObjectForKey("name") as? NSString
        image = aDecoder.decodeObjectForKey("image") as? UIImage
        isAuthenticated = aDecoder.decodeObjectForKey("isAuthenticated") as Bool
        hasPartner = aDecoder.decodeObjectForKey("hasPartner") as Bool
        statusType = aDecoder.decodeObjectForKey("statusType") as StatusType?
        statusDate = aDecoder.decodeObjectForKey("statusDate") as NSDate?
        statuses = aDecoder.decodeObjectForKey("statuses") as Array<Status>
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(image, forKey: "image")
        aCoder.encodeObject(isAuthenticated, forKey: "isAuthenticated")
        aCoder.encodeObject(hasPartner, forKey: "hasPartner")
        aCoder.encodeObject(statusType, forKey: "statusType")
        aCoder.encodeObject(statusDate, forKey: "statusDate")
        aCoder.encodeObject(statuses, forKey: "statuses")
    }

    func save() -> Profile {
        assert(NSThread.currentThread().isMainThread, "call from main thread")

        let userDefaults = NSUserDefaults.standardUserDefaults()
        let data = NSKeyedArchiver.archivedDataWithRootObject(self)
        userDefaults.setObject(data, forKey: self.dynamicType.key)
        userDefaults.synchronize()
        return self
    }

    class func read() -> Profile! {
        assert(NSThread.currentThread().isMainThread, "call from main thread")

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
        instance.statuses = unarchivedProfile.statuses

        return instance
    }

    func description() -> NSString {
        return NSString(format: "-----------------\n class = \(NSStringFromClass(self.dynamicType)),\n id = \(id),\n isAuthenticated = \(isAuthenticated),\n hasPartner = \(hasPartner),\n name = \(name),\n image = \(image),\n statusType = \(statusType),\n statusDate = \(statusDate)\n-----------------\n")
    }
}
