//
//  AppDelegate.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/08/10.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        applayAppearance()
        setupParse()

        application.registerForRemoteNotifications()
        application.registerUserNotificationSettings(createNotificationSettings())

        return true
    }

    var godItStatusTypes: StatusTypes {
        return StatusTypes(rawValue: 5)!
    }
    
    var otherNotificationAction:(String, String) {
        return ("Other", "other")
    }
    var godItAction: UIMutableUserNotificationAction {
        var action = UIMutableUserNotificationAction()
        action.title = godItStatusTypes.statusType.name
        action.identifier = godItStatusTypes.statusType.identifier
        action.activationMode = .Background
        return action
    }
    var otherAction: UIMutableUserNotificationAction {
        var action = UIMutableUserNotificationAction()
        action.title = otherNotificationAction.0
        action.identifier = otherNotificationAction.1
        action.activationMode = .Foreground
        action.authenticationRequired = true
        return action
    }

    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        if let identifier = identifier {
            switch identifier {
            case godItStatusTypes.statusType.identifier:
                let op = SendMyStatusOperation(statusTypes: godItStatusTypes)
                op.completionBlock = completionHandler
                dispatchAsyncOperation(op)
                break
            default:
                break
            }
        }
    }

    private func createNotificationSettings() -> UIUserNotificationSettings {
        let replayCategory = UIMutableUserNotificationCategory()
        replayCategory.identifier = "ReceivedMessage"
        replayCategory.setActions([otherAction, godItAction], forContext: .Default)
        var categories = NSMutableSet()
        categories.addObject(replayCategory)
        return UIUserNotificationSettings(forTypes: (.Badge | .Sound | .Alert), categories: categories as Set<NSObject>)
    }

    private func applayAppearance() {
        UINavigationBar.appearance().tintColor = UIColor.blackColor()
        UISwitch.appearance().onTintColor = UIColor.darkGrayColor()
        UINavigationBar.appearance().barTintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().tintColor = UIColor(white: 0.15, alpha: 1)
    }

    private func setupParse() {
        ParseCrashReporting.enable()
        Parse.setApplicationId("Wq5i73uv70sYS1tI9anCe4WE9Iz5YVQtWof988EJ", clientKey: "9o1GdrDNpDfCN0eTkWYEsENAoftTkZgC7EQpeghc")
        PFFacebookUtils.initializeFacebook()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        Logger.debug("didFailToRegisterForRemoteNotificationsWithError:\(error)")
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        dispatchAsyncMultiThread({
            if !installation.save() { self.dispatchAsyncMainThread({ NSError.code(.Unknown).toast() }) }
        })
    }

    // ???: Background Fetchを実装
    // @see http://www.gaprot.jp/pickup/ios7/vol1/
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        notify(userInfo)
    }
    
    var mainViewController: MainViewController {
        return (self.window!.rootViewController as! UINavigationController).viewControllers[0] as! MainViewController
    }

    func notify(userInfo: [NSObject : AnyObject]) {
        var op: BaseOperation? = nil

        // TODO: enum化
        if let category = userInfo["aps"]?["category"] as? String {
            switch category {
            case "AddedPartner":
                op = AddPartnerOperation(candidatePartnerId: userInfo["objectId"] as! String)
                break
            case "ReceivedMessage":
                if MyProfile.read().hasPartner {
                    op = UpdatePartnerOperation(partnerId: Partner.read().id!).enableHUD(false)
                }
                break
            default:
                break
            }
        }
        if let op = op {
            dispatchAsyncOperation(op)
        }
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBAppCall.handleOpenURL(url, sourceApplication:sourceApplication, withSession:PFFacebookUtils.session())
    }

    let loginToFBOp: LoginToFBOperation = LoginToFBOperation()

    func applicationDidBecomeActive(application: UIApplication) {
        FBAppEvents.activateApp()
        FBAppCall.handleDidBecomeActiveWithSession(PFFacebookUtils.session())

        let myProfile = MyProfile.read()
        if !myProfile.isAuthenticated {
            showSignInFacebookAlertIfNeeded()
            return
        }

        if myProfile.hasPartner {
            let op = UpdatePartnerOperation(partnerId: Partner.read().id!).enableHUD(false)
            dispatchAsyncOperation(op)
        }
        let op = UpdateMyProfileOperation().enableHUD(false)
        dispatchAsyncOperation(op)
    }
    
    func showSignInFacebookAlertIfNeeded() -> Bool {
        if MyProfile.read().isAuthenticated {
            return false
        }
        if loginToFBOp.executing {
            return false
        }
        let alert = UIAlertController(title: "Login With Facebook?", message: "", preferredStyle: .Alert)
        let action = UIAlertAction(title: "Login", style: .Default) { action in
            self.dispatchAsyncOperation(self.loginToFBOp)
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        window!.rootViewController!.presentViewController(alert, animated: true, completion: nil)
        return true
    }

    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.ryoabe..PARTNER" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return (urls[urls.count-1] as? NSURL)!
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("PARTNER", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("PARTNER.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict as [NSObject : AnyObject])
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
        }()


    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    
}

