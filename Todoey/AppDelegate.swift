//
//  AppDelegate.swift
//  Destini
//
//  Created by Philipp Muellauer on 01/09/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let config = Realm.Configuration(
            schemaVersion: 3, // Set the new schema version.
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 3 {
//                    // The enumerateObjects(ofType:_:) method iterates over
//                    // every Person object stored in the Realm file
//                    migration.enumerateObjects(ofType: Category.className()) { oldObject, newObject in
//                        // combine name fields into a single field
//                        let firstName = oldObject!["firstName"] as? String
//                        let lastName = oldObject!["lastName"] as? String
//                        newObject!["fullName"] = "\(firstName!) \(lastName!)"
//                    }
                }
            }
        )
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        print(Realm.Configuration.defaultConfiguration.fileURL?.absoluteString ?? "Realm missing")
        
        do {
            _ = try Realm()
        } catch {
            print("Error initialising new realm, \(error)")
        }
        
        return true
    }

}

