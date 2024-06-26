//
//  AppDelegate.swift
//  ToDoApp2
//
//  Created by Марк Фокша on 04.12.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        #if targetEnvironment(simulator)
        if CommandLine.arguments.contains("--UITesting") {
            resetState()
        }
        #endif
        
        return true
    }
    
    private func resetState() {
        guard let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
              let url = URL(string: "\(documentPath)tasks.plist") else { return }
        let fileManager = FileManager.default
        
        try? fileManager.removeItem(at: url)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

