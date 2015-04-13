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
            self.profile.name = self.pfProfile!.username
            self.profile.image = profileImageData == nil ? nil : UIImage(data: profileImageData!)
            self.profile.isAuthenticated = self.pfProfile!.isAuthenticated
            self.savePfStatuses(pfStatuses)
            self.profile.save()
            self.saveMyPartner()
            self.profile.save()
        }
        return .Success(nil)
    }
    
    func saveMyPartner(){
        if self.pfProfile.partner == nil {
            self.profile.partner = nil
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

    func savePfStatuses(pfStatuses: Array<PFStatus>?) {
        if let pfStatuses = pfStatuses {
            if !pfStatuses.isEmpty {
                for pfStatus in pfStatuses {
                    self.profile.appendStatuses(PartnersStatus(types: pfStatus.types!, date: pfStatus.date!))
                }
                return
            }
        }
        self.profile.removeAllStatuses()
    }
}
