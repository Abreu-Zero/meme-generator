//
//  InjectorViewController.swift
//  MemeGenerator
//
//  Created by Henrique Abreu on 25/08/2020.
//  Copyright © 2020 Henrique Abreu. All rights reserved.
//

import UIKit

class InjectorViewController: UITabBarController, UITabBarControllerDelegate{
    

    let dataController = DataController(modelName: "MemeGenerator")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        dataController.load()

        print("DataController Loaded")
        for child in viewControllers ?? [] {
            if let vc = child as? UINavigationController{
                let nvc = vc.topViewController as! DataControllerProtocol
                nvc.setDataContoller(dataController: dataController)
            }
        }
    }
    

    

    

}

