//
//  AppDelegate.swift
//  openAiChat
//
//  Created by ethan on 2023/1/31.
//

import UIKit
import FirebaseCore
import FirebaseDatabase
import Combine


struct ApiKey: Codable {
    var apiKey: String
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let input: PassthroughSubject<AIViewModel.Input, Never> = .init()
    
    private lazy var databasePath: DatabaseReference? = {
        let ref = Database.database().reference()
        return ref
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        handleOpenAIClient()
        return true
    }
    
    func handleOpenAIClient() {
        input.send(.startToConnect(true))
        let decoder = JSONDecoder()
        guard let databasePath = databasePath else { return }
        databasePath.observe(.value) { [weak self] snapshot,_  in
            guard let json = snapshot.value as? [String: String] else { return }
            do {
                let apiData = try JSONSerialization.data(withJSONObject: json)
                let decodedData = try decoder.decode(ApiKey.self, from: apiData)
                APICaller.shared.setupClient(apiKey: decodedData.apiKey)
                self?.input.send((.startToConnect(false)))
            } catch {
                print("an error occurred", error)
            }
        }
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

