//
//  SceneDelegate.swift
//  Timer
//
//  Created by Sergey Savinkov on 27.06.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        let mainVC = ViewController()
        
        window.rootViewController = UINavigationController(rootViewController: mainVC)
        window.makeKeyAndVisible()
    }
}
