//
//  Profile.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/02.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

class Profile: NSObject, NSCoding{
    
    dynamic var name: NSString?
    dynamic var image: UIImage?

    class var key: NSString {
        return NSStringFromClass(self).componentsSeparatedByString(".").last!;
    }
    
    class var sharedInstance : Profile {
        assert(false, "overrideして下さい")
        return Profile()
    }

    init(name: NSString?, image: UIImage?){
        self.name = name
        self.image = image
    }

    convenience override init(){
        self.init(name:nil, image:nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey("name") as? NSString
        self.image = aDecoder.decodeObjectForKey("image") as? UIImage
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.image, forKey: "image")
    }

    class func save(name: NSString, image: UIImage) -> Profile {
        let profile = self.sharedInstance
        profile.name = name
        profile.image = image
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let data = NSKeyedArchiver.archivedDataWithRootObject(profile)
        userDefaults.setObject(data, forKey: key)
        userDefaults.synchronize()
        return profile
    }

    class func read() -> Profile?{
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let data = userDefaults.dataForKey(key)
        return data == nil ? self.sharedInstance : NSKeyedUnarchiver.unarchiveObjectWithData(data!) as? Profile
    }
}
