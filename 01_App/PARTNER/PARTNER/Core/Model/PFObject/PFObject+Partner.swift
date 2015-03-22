//
//  PFObject+Partner.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/03/21.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

extension PFUser {
    class func currentMyProfile() -> PFMyProfile {
        let currentUser = PFUser.currentUser()
        return PFMyProfile(user: currentUser)
    }
    class func currentPartner(partnerId: NSString) -> PFPartner {
        let pfParter = PFUser.query().getObjectWithId(partnerId) as PFUser
        return PFPartner(user: pfParter)
    }
}

class PFObjectBase {
    var pfObject: PFObject!
    init(object: PFObject) {
        self.pfObject = object
    }
    init(className: String){
        self.pfObject = PFObject(className: className)
    }
    init(className: String, objectId: String) {
        self.pfObject = PFQuery.getObjectOfClass(className, objectId: objectId)
    }
    func save(error: NSErrorPointer) {
        pfObject.save(error)
    }
}

class PFProfile: PFObjectBase {
    init(user: PFUser) {
        super.init(object: user)
    }
    var pfUser: PFUser {
        return pfObject as PFUser
    }
    var objectId: NSString {
        return pfUser.objectId
    }
    var username: NSString {
        get {
            return pfUser.username
        }
        set {
            pfUser.username = newValue
        }
    }
    var hasPartner: Bool {
        get {
            return pfUser["hasPartner"] as Bool
        }
        set {
            pfUser["hasPartner"] = newValue
        }
        
    }
    var profileImage: PFFile {
        get {
            return pfUser["profileImage"] as PFFile
        }
        set {
            pfUser["profileImage"] = newValue
        }
    }
    var fbId: String {
        get {
            return pfUser["fbId"] as String
        }
        set {
            pfUser["fbId"] = newValue
        }
    }
    var partner: PFUser {
        get {
            return pfUser["partner"] as PFUser
        }
        set {
            pfUser["partner"] = newValue
        }
    }
    var statuses: Array<PFStatus>? {
        get {
            if let statusPointer = pfUser["statuses"] as? NSArray {
                var statuses: Array<PFStatus> = []
                for pointer in pfUser["statuses"] as NSArray {
                    statuses.append(PFStatus(statusId: pointer.objectId))
                }
                return statuses
            }
            return nil
        }
        set {
            pfUser.addObjectsFromArray(newValue!.map{ $0.pfStatus }, forKey: "statuses")
        }
    }
    var isAuthenticated: Bool {
        return pfUser.isAuthenticated()
    }
}

class PFMyProfile: PFProfile {

}

class PFPartner: PFProfile {
    
}

class PFStatus: PFObjectBase {
    init(){
        super.init(className: "Status")
    }
    init(statusId: String) {
        super.init(className: "Status", objectId: statusId)
    }
    var pfStatus: PFObject {
        return pfObject
    }
    var types: StatusTypes {
        get {
            let types = pfStatus["type"] as NSInteger
            return StatusTypes(rawValue: types)!
        }
        set {
            pfStatus.setObject(NSNumber(integer: newValue.rawValue), forKey: "type")
        }
    }
    var date: NSDate {
        get {
            return pfStatus["date"] as NSDate
        }
        set {
            pfStatus.setObject(newValue, forKey: "date")
        }
    }
}