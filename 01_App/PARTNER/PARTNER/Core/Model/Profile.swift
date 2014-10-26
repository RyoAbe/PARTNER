//
//  Profile.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/02.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

class Profile:NSObject, NSCoding{
    
    dynamic var name: NSString!;
    dynamic var image: UIImage?;

    class var sharedInstance : MyProfile {
        struct Static {
            static let instance : MyProfile = MyProfile()
        }
        return Static.instance
    }

    init(name:NSString, image:UIImage?){
        self.name = name
        self.image = image
    }

    convenience override init(){
        self.init(name:"", image:nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey("name") as NSString
        self.image = aDecoder.decodeObjectForKey("image") as? UIImage
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.image, forKey: "image")   
    }
    
    class func save(name:NSString, image:UIImage) -> Profile{
        // TODO:本当は子としてStaticメソッドを呼びたい
        let profile = MyProfile.sharedInstance;
        profile.name = name;
        profile.image = image;
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let data = NSKeyedArchiver.archivedDataWithRootObject(profile);
        userDefaults.setObject(data, forKey: Profile.key())
        userDefaults.synchronize()
        return profile
    }
    
    class func read() -> Profile?{
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let data = userDefaults.dataForKey(Profile.key())

        // TODO:本当は子としてStaticメソッドを呼びたい
        return data == nil ? MyProfile.sharedInstance : NSKeyedUnarchiver.unarchiveObjectWithData(data!) as? Profile
    }

    class func key() -> String {
        return NSStringFromClass(self).componentsSeparatedByString(".").last!;
    }
}
