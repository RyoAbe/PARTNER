//
//  AddPartnerOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/01/01.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

// ???: 追加出来なかった場合など、ローカルのみ保存されてしまう可能性がある。ロールバックの仕組みを作りたい
class AddPartnerOperation: BaseOperation {
    var candidatePartner: PFPartner!
    var candidatePartnerId : String!

    convenience init(candidatePartnerId : String){
        self.init()
        self.candidatePartnerId = candidatePartnerId
        self.executeAsyncBlock = { self.requestCandidatePartner() }
    }

    convenience init(candidatePartner: PFPartner){
        self.init()
        self.candidatePartner = candidatePartner
        self.executeAsyncBlock = { self.savePartnerForServer() }
    }

    func requestCandidatePartner() {
        var error: NSError?
        if let pfUser = PFUser.query()!.getObjectWithId(candidatePartnerId, error: &error) as? PFUser {
            candidatePartner = PFPartner(user: pfUser)
            savePartnerForServer()
            return
        }
        finishWithError(error == nil ? NSError.code(.NotFoundUser) : error)
    }

    func savePartnerForServer() {
        var error: NSError?
        let pfMyProfile = PFUser.currentMyProfile()

        pfMyProfile.partner = candidatePartner.pfUser
        pfMyProfile.removeAllStatuses()
        pfMyProfile.saveInBackgroundWithBlock{ success, error in
            if !success {
                self.finishWithError(error)
                return
            }
            self.savePartnerForLocal()
        }
    }

    func savePartnerForLocal() {
        // TODO: キューを使って全体として処理をまとめる
        self.needHideHUD(false)
        self.dispatchAsyncMainThread {

            // 取得したcandidatePartnerを使用してパートナーのみの情報を更新
            let op = UpdatePartnerOperation(partnerId: self.candidatePartner.objectId).needShowHUD(false)
            op.completionBlock = {
                // パートナーが追加されたので自分の情報を更新
                self.dispatchAsyncOperation(UpdateMyProfileOperation().enableHUD(false))
            }
            self.dispatchAsyncOperation(op)
        }

        // パートナーが存在していて、なおかつ自分のobjectIdと一致していればreturn
        if let partner = candidatePartner.partner where partner.objectId == PFUser.currentMyProfile().objectId {
            self.finish()
            return
        }

        dispatchAsyncMainThread {
            if let id = Partner.read().id {
                PFCloud.callFunctionInBackground("removePartner", withParameters: ["partnerId": id]) { response, error in
                    Logger.debug("response=\(response)")
                }
            }
        }
        
        PFCloud.callFunctionInBackground("addPartner", withParameters: ["partnerId": candidatePartner.objectId]) { response, error in
            Logger.debug("response=\(response)")
        }

        notify()
    }
    
    func notify() {
        let pfMyProfile = PFUser.currentUser()!
        let userQuery = PFUser.query()!.whereKey("objectId", equalTo: candidatePartner.objectId)
        let pushQuery = PFInstallation.query()!.whereKey("user", matchesQuery:userQuery)
        let push = PFPush()
        push.setQuery(pushQuery)
        push.setData(["alert"            : NSString(format: LocalizedString.key("AddedPartnerFormat"), pfMyProfile.username!),
                      "objectId"         : pfMyProfile.objectId!,
                      "category"         : APSCategory.AddedPartner.rawValue ])
        var error: NSError?
        push.sendPush(&error)
        if error != nil {
            self.finishWithError(error)
            return
        }
        self.finish()
    }
}
