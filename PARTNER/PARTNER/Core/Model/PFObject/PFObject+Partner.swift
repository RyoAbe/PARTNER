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
        return PFMyProfile(user: PFUser.currentUser()!)
    }
    class func currentPartner(partnerId: String) -> PFPartner? {
        if let pfObject = PFUser.query()!.getObjectWithId(partnerId) as? PFUser {
            return PFPartner(user: pfObject)
        }
        return nil
    }
}

class PFObjectBase {
    var pfObject: PFObject?
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
        pfObject!.save(error)
    }
    func saveInBackgroundWithBlock(block: (Bool, NSError?) -> Void) {
        pfObject!.saveInBackgroundWithBlock(block)
    }
}

class PFProfile: PFObjectBase {
    init(user: PFUser) {
        super.init(object: user)
    }
    var pfUser: PFUser { return pfObject as! PFUser }
    var objectId: String { return pfUser.objectId! }
    var isAuthenticated: Bool { return pfUser.isAuthenticated() }
    var username: String {
        get { return pfUser.username! }
        set { pfUser.username = newValue }
    }
    var hasPartner: Bool { return self.partner != nil }
    var profileImage: PFFile {
        get { return pfUser["profileImage"] as! PFFile }
        set { pfUser["profileImage"] = newValue }
    }
    var fbId: String {
        get { return pfUser["fbId"] as! String }
        set { pfUser["fbId"] = newValue }
    }
    var partner: PFUser? {
        get { return pfUser["partner"] as? PFUser }
        set { pfUser["partner"] = newValue != nil ? newValue : NSNull() }
    }
    var statuses: Array<PFStatus>? {
        get {
            if let statusPointers = pfUser["statuses"] as? Array<PFObject> {
                var statuses: Array<PFStatus> = []
                for statusPointer in statusPointers {
                    statuses.append(PFStatus(statusId: statusPointer.objectId!))
                }
                return statuses
            }
            return nil
        }
        set {
            if let statusPointers = pfUser["statuses"] as? Array<PFObject> {
                if MaxSatuses <= statusPointers.count {
                    pfUser.removeObjectsInArray([statusPointers.first!], forKey: "statuses")
                }
            }
            pfUser.addObjectsFromArray(newValue!.map{ $0.pfObject! }, forKey: "statuses")
        }
    }
    func removeAllStatuses() {
        if var statusPointers = pfUser["statuses"] as? Array<PFObject> {
            statusPointers = []
        }
    }
}

class PFMyProfile: PFProfile {

}

class PFPartner: PFProfile {
    override var isAuthenticated: Bool { return true }
}

class PFStatus: PFObjectBase {
    init(){
        super.init(className: "Status")
    }
    init(statusId: String) {
        super.init(className: "Status", objectId: statusId)
    }
    var types: StatusTypes? {
        get {
            if let type = pfObject?["type"] as? NSInteger {
                return StatusTypes(rawValue: type)
            }
            return nil
            }
        set {
            if let newValue = newValue {
                pfObject?.setObject(NSNumber(integer: newValue.rawValue), forKey: "type")
                return
            }
            pfObject?.setObject(NSNull(), forKey: "type")
        }
    }
    var date: NSDate? {
        get {
            if let date = pfObject?["date"] as? NSDate {
                return date
            }
            return nil
        }
        set {
            if let newValue = newValue {
                pfObject?.setObject(newValue, forKey: "date")
                return
            }
            pfObject?.setObject(NSNull(), forKey: "date")
        }
    }
}