//
//  UpdateProfileOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/04/12.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

class UpdateProfileOperation: BaseOperation {
    var pfProfile: PFProfile!
    var profile : Profile!
    override init(){
        super.init()
        self.executeSerialBlock = {
            return self.updateProfile()
        }
    }
    func updateProfile() -> BaseOperationResult {
        if pfProfile == nil {
            return .Failure(NSError.code(.Unknown))
        }
        let pfStatuses = pfProfile!.statuses
        let profileImageData = pfProfile!.profileImage.getData()
        self.dispatchAsyncMainThread{
            self.profile.id = self.pfProfile!.objectId
            Logger.debug("self.profile=\(self.profile)")
            self.profile.name = self.pfProfile!.username
            self.profile.image = profileImageData == nil ? nil : UIImage(data: profileImageData!)
            self.profile.isAuthenticated = self.pfProfile!.isAuthenticated
            self.saveStatuses(pfStatuses)
            self.profile.save()
            Logger.debug("self.profile=\(self.profile)")

            self.saveMyPartner()
        }
        return .Success(nil)
    }
    
    func saveMyPartner(){
        if pfProfile.partner == nil {
            profile.partner = nil
            return
        }

        if let myProfileId = MyProfile.read().id, let partnersId = Partner.read().id {
            let myProfile = MyProfile.read()
            let partner = Partner.read()
            myProfile.partner = partner
            partner.partner = myProfile
            myProfile.save()
            partner.save()
            return
        }
        return
    }
    
    func status(types: StatusTypes, date: NSDate) -> Status {
        assert(false)
        return Status(types: types, date: date)
    }

    func saveStatuses(pfStatuses: [PFStatus]?) {
        // 一旦ローカルのデータを消してから再度セット
        profile.removeAllStatuses()
        if let pfStatuses = pfStatuses {
            if !pfStatuses.isEmpty {
                for pfStatus in pfStatuses {
                    // ???: なぜこんなことが必要なのだろうか、、
                    if let types = pfStatus.types, let date = pfStatus.date {
                        let status = self.status(types, date: date)
                        self.profile.appendStatuses(status)
                    }
                }
            }
        }
    }
}
