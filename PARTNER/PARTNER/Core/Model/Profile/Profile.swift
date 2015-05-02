//
//  Profile.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/02.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

// ???: とりあえず20件にした
let MaxSatuses = 20

class Profile: NSObject, NSCoding {

    dynamic var id: String?
    dynamic var name: String?
    dynamic var image: UIImage?
    dynamic var isAuthenticated: Bool
    dynamic var partner: Profile?
    private(set) dynamic var statuses: [Status]?
    var hasPartner: Bool {
        return partner != nil
    }

    class var sharedInstance : Profile {
        assert(false, "overrideして下さい")
        return Profile()
    }

    init(id: String?, name: String?, image: UIImage?, isAuthenticated: Bool, partner: Profile?, statuses: [Status]) {
        self.id = id
        self.name = name
        self.image = image
        self.isAuthenticated = isAuthenticated
        self.partner = partner
        self.statuses = statuses
    }

    convenience override init(){
        self.init(id: nil, name: nil, image: nil, isAuthenticated: false, partner: nil, statuses: [])
    }

    required init(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObjectForKey("id") as? String
        name = aDecoder.decodeObjectForKey("name") as? String
        image = aDecoder.decodeObjectForKey("image") as? UIImage
        isAuthenticated = aDecoder.decodeObjectForKey("isAuthenticated") as! Bool
        partner = aDecoder.decodeObjectForKey("partner") as? Profile
        statuses = aDecoder.decodeObjectForKey("statuses") as? [Status]
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(image, forKey: "image")
        aCoder.encodeObject(isAuthenticated, forKey: "isAuthenticated")
        aCoder.encodeObject(partner, forKey: "partner")
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
        if MaxSatuses <= statuses?.count {
            statuses?.removeAtIndex(0)
        }
        statuses?.append(status)
    }

    func removeAllStatuses() {
        statuses?.removeAll(keepCapacity: false)
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
        instance.id = unarchivedProfile.id
        instance.name = unarchivedProfile.name
        instance.image = unarchivedProfile.image
        instance.partner = unarchivedProfile.partner
        instance.statuses = unarchivedProfile.statuses
        return instance
    }

    override var description: String {
        let statusesString = join(", ", (statuses?.map{ "types=\($0.types), date=\($0.date)" })! )
        return "id: \(id), name: \(name), statuses: [\(statusesString)], statuses.count:\(statuses?.count)"
    }
}
