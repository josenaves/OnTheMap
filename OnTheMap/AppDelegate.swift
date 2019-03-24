//
//  AppDelegate.swift
//  OnTheMap
//
//  Created by José Naves Moura Neto on 18/02/19.
//  Copyright © 2019 José Naves Moura Neto. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let loginController = window?.rootViewController as? LoginViewController {
            loginController.udacityClient = UdacityApiClient()
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension UIApplication {
    
    func openDefaultBrowser(accessingAddress addressText: String) {
        var addressText = addressText
        
        // If the address text is not a valid address, embed it in a google search.
        let componentsSplitted = addressText.split(separator: ".")
        if componentsSplitted.count == 1 {
            addressText = "https://www.google.com/search?q=\(componentsSplitted.first!)"
        }
        
        guard var addressURL = URL(string: addressText),
            var components = URLComponents(url: addressURL, resolvingAgainstBaseURL: true) else {
                assertionFailure("Could not mount the url.")
                return
        }
        
        if components.scheme == nil {
            components.scheme = "https"
            addressURL = components.url!
        }
        
        if UIApplication.shared.canOpenURL(addressURL) {
            UIApplication.shared.open(addressURL, options: [:], completionHandler: nil)
        }
    }
}
