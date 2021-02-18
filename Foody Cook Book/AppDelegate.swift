//
//  AppDelegate.swift
//  Foody Cook Book
//
//  Created by Arijit Das on 18/02/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let rootViewController = self.window?.rootViewController as? UINavigationController
        rootViewController?.pushViewController(viewController, animated: true)
        
        return true
    }


}

