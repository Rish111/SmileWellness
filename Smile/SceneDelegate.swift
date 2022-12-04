//
//  SceneDelegate.swift
//  Smile
//
//  Created by Rishul Dodhia on 3/1/20.
//  Copyright © 2020 Rishul Dodhia. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    @available(iOS 13, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // extra
        
        //UserDefaults.standard.removeObject(forKey: "walkThroughSeen")

        guard let _ = (scene as? UIWindowScene) else { return }
        
        let firstLaunch = UserDefaults.standard.bool(forKey: "walkThroughSeen")
        if firstLaunch  {
         
          print("Not first launch.")
            self.window = UIWindow(frame: UIScreen.main.bounds)

         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let initialViewController = storyboard.instantiateViewController(withIdentifier: "ViewController")
         if let windowScene = scene as? UIWindowScene {
         let window = UIWindow(windowScene: windowScene)
         window.rootViewController = initialViewController
         self.window = window
         window.makeKeyAndVisible()
              }

        } else {
          print("First launch, setting NSUserDefault.")

         self.window = UIWindow(frame: UIScreen.main.bounds)

         let storyboard = UIStoryboard(name: "Main", bundle: nil)

         let initialViewController = storyboard.instantiateViewController(withIdentifier: "ob1")
         
         if let windowScene = scene as? UIWindowScene {
         let window = UIWindow(windowScene: windowScene)
         window.rootViewController = initialViewController
         self.window = window
         window.makeKeyAndVisible()
             }
         }
        
       
    }
    
    @available(iOS 13, *)
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    @available(iOS 13, *)
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    @available(iOS 13, *)
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    @available(iOS 13, *)
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    @available(iOS 13, *)
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}
