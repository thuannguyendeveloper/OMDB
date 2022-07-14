//
//  AppDelegate.swift
//  OMDB
//
//  Created by ThuanNguyen on 7/14/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.config()
        return true
    }
    
    private func config() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let movieVC = MovieListViewController(nibName: "MovieListViewController", bundle: nil)
        self.window?.rootViewController = UINavigationController(rootViewController: movieVC)
        self.window?.overrideUserInterfaceStyle = .light
        self.window?.makeKeyAndVisible()
    }


}

