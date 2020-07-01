//
//  AppDelegate.swift
//  MyChengyu
//
//  Created by Antoine on 01/07/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //MARK: - Properties
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        do {
            let _ = try Realm()
        } catch let error as NSError {
            print("❌ UNABLE TO INITIALIZE REALM DATABASE: \(error)")
        }
        
        configurateUser()
        
        window = UIWindow()
        window?.backgroundColor = UIColor(named: "ChengyuBackground")
        let nav = UINavigationController(rootViewController: MenuVC())
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        
        return true
    }
    
    
    private func configurateUser() {
        let realm = try! Realm()
        let decks = realm.objects(Deck.self)
        
        if decks.count == 0 {
            let newDeck = Deck()
            newDeck.name = String.localize(forKey: "DEFAULT.FAVORITES")
            try! realm.write {
                realm.add(newDeck)
            }
        }
    }
}
