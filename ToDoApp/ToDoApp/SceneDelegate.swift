//
//  SceneDelegate.swift
//  ToDoApp
//
//  Created by Sawy on 26.11.23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: Properties
    private let coordinator: ApplicationCoordinator = ApplicationCoordinator()
    
    private var window: UIWindow? {
        return coordinator.window
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        coordinator.start(windowScene: windowScene)
    }
}

