//
//  UITabBarViewController.swift
//  MemeGenerator
//
//  Created by Henrique Abreu on 24/08/2020.
//  Copyright © 2020 Henrique Abreu. All rights reserved.
//

import UIKit

class UITabBarViewController: UITabBarController {

    let dataController = DataController(modelName: "MemeGenerator")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //dataController.load()
        
        let memeTable = viewControllers![0] as! MemeTableViewController
        //memeTable.dataController = dataController
        let memeCol = viewControllers![1] as! MemeCollectionViewController
        //memeCol.dataController = dataController

    }


}
