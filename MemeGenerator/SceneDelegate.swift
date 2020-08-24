//
//  SceneDelegate.swift
//  MemeGenerator
//
//  Created by Henrique Abreu on 29/06/2020.
//  Copyright © 2020 Henrique Abreu. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let dataController = DataController(modelName: "MemeGenerator")



    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        dataController.load()
        
        let navigationController = window?.rootViewController as! UINavigationController
        let firstVC = navigationController.topViewController as! MemeTableViewController
        firstVC.dataController = dataController
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    

}

