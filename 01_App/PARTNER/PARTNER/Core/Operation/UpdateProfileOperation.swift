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
            self.profile.id = self.pfProfile!.fbId
            self.profile.name = self.pfProfile!.username
            self.profile.image = profileImageData == nil ? nil : UIImage(data: profileImageData!)
            self.profile.isAuthenticated = self.pfProfile!.isAuthenticated
            self.profile.hasPartner = self.pfProfile!.hasPartner
            if let pfStatuses = pfStatuses {
                self.savePfStatuses(pfStatuses)
            }
            self.profile.save()
        }
        return .Success(nil)
    }

    func savePfStatuses(pfStatuses: Array<PFStatus>) {
        let pfStatus = pfStatuses.last!
        if let types = pfStatus.types, date = pfStatus.date {
            let status = PartnersStatus(types: types, date: date)
            self.profile.statusDate = status.date
            self.profile.statusType = status.types.statusType
            for pfStatus in pfStatuses {
                self.profile.appendStatuses(PartnersStatus(types: pfStatus.types!, date: pfStatus.date!))
            }
            return
        }
        self.profile.statusDate = nil
        self.profile.statusType = nil
        self.profile.removeAllStatuses()
    }
}
