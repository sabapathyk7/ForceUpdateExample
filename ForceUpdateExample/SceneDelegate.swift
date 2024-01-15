//
//  SceneDelegate.swift
//  ForceUpdateExample
//
//  Created by kanagasabapathy on 15/01/24.
//

import UIKit

enum AppType {
    case uikit
    case swiftUI
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo
               session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        guard let window = window as UIWindow? else {
            window?.makeKeyAndVisible()
            return
        }
        changeAppAction(window: window, appType: .swiftUI)
    }

    private func changeAppAction(window: UIWindow, appType: AppType) {
        var viewController: UIViewController
        switch appType {
        case .uikit:
            viewController = ForceUpdateViewController()
        case .swiftUI:
            viewController = HostingSwiftUIController()
        }
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}
