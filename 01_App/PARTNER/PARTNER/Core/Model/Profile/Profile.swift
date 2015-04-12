//
//  Profile.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/02.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

// TODO: 100に戻す
let MaxSatuses = 100

class Profile: NSObject, NSCoding{

    dynamic var id: String!
    dynamic var name: String!
    dynamic var image: UIImage?
    dynamic var isAuthenticated: Bool
    dynamic var hasPartner: Bool
    // ???: いらなくなる
    dynamic var statusType: StatusType?
    dynamic var statusDate: NSDate?
    private dynamic var statuses: Array<Status>

    var myStatuses: Array<Status> {
        return statuses
    }
    
    class var sharedInstance : Profile {
        assert(false, "overrideして下さい")
        return Profile()
    }

    init(id: String?, name: String?, image: UIImage?, isAuthenticated: Bool, hasPartner: Bool, statusType: StatusType?, statusDate: NSDate?, statuses: Array<Status>) {
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
        id = aDecoder.decodeObjectForKey("id") as? String
        name = aDecoder.decodeObjectForKey("name") as? String
        image = aDecoder.decodeObjectForKey("image") as? UIImage
        isAuthenticated = aDecoder.decodeObjectForKey("isAuthenticated") as! Bool
        hasPartner = aDecoder.decodeObjectForKey("hasPartner") as! Bool
        statusType = aDecoder.decodeObjectForKey("statusType") as! StatusType?
        statusDate = aDecoder.decodeObjectForKey("statusDate") as! NSDate?
        statuses = aDecoder.decodeObjectForKey("statuses") as! Array<Status>
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
        userDefaults.setObject(data, forKey: className)
        userDefaults.synchronize()
        return self
    }
    
    func appendStatuses(status: Status) {
        if MaxSatuses <= statuses.count {
            statuses.removeAtIndex(0)
        }
        statuses.append(status)
    }
    
    func removeAllStatuses() {
        statuses.removeAll(keepCapacity: false)
    }

    class func read() -> Profile! {
        assert(NSThread.currentThread().isMainThread, "call from main thread")

        if let data = NSUserDefaults.standardUserDefaults().dataForKey(className) {
            return createWithData(data)
        }
        return self.sharedInstance.save()
    }
    
    class func createWithData(data: NSData) -> Profile! {
        let instance = self.sharedInstance

        let unarchivedProfile = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! Profile
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

//    func description() -> NSString {
//        return NSString(format: "-----------------\n class = \(className),\n id = \(id),\n isAuthenticated = \(isAuthenticated),\n hasPartner = \(hasPartner),\n name = \(name),\n image = \(image),\n statusType = \(statusType),\n statusDate = \(statusDate)\n-----------------\n")
//    }
}
