//
//  AppDelegate.swift
//  photo-library-mirai
//
//  Created by Achmad Abdul Aziz on 18/06/20.
//  Copyright © 2020 Achmad Abdul Aziz. All rights reserved.
//

import UIKit
import Photos

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined{
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized{
                    self.goToVC()
                } else {
                    let alert = UIAlertController(title: "Photo Accesss Denied", message: "App needs accesss to photos library", preferredStyle: .alert)
                    let btnOK = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(btnOK)
                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                }
            }
        } else if photos == .authorized{
            goToVC()
        }
        
        return true
    }
    
    func goToVC(){
        DispatchQueue.main.async {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            if let window = self.window{
                window.backgroundColor = UIColor.white
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let view = storyboard.instantiateViewController(withIdentifier: "viewController") as? ViewController
                
                let nav = UINavigationController(rootViewController: view!)
                
                window.rootViewController = nav
                window.makeKeyAndVisible()
            }
        }
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

