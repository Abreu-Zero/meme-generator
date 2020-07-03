//
//  ShareViewController.swift
//  MemeGenerator
//
//  Created by Henrique Abreu on 02/07/2020.
//  Copyright © 2020 Henrique Abreu. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var meme: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        imageView.image = meme
    }
    
    @IBAction func share(_ sender: Any) {
        let shareController = UIActivityViewController(activityItems: [meme!], applicationActivities: [])
        shareController.completionWithItemsHandler = {(activity: UIActivity.ActivityType?, completed: Bool,  _: [Any]?, error: Error?) in

        }
        
        self.present(shareController, animated: true, completion: nil)
    }
 
   

}
