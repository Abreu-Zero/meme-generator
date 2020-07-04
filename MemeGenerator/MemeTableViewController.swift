//
//  MemeTableViewController.swift
//  MemeGenerator
//
//  Created by Henrique Abreu on 04/07/2020.
//  Copyright © 2020 Henrique Abreu. All rights reserved.
//

import UIKit

import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme] {
       return (UIApplication.shared.delegate as! AppDelegate).memes
   }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        self.tabBarController?.tabBar.isHidden = false

    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let meme = memes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeTableCell", for: indexPath) as! MemeTableCell
        
        cell.topText.text = meme.topText
        cell.bottomText.text = meme.bottomText
        cell.memeImageView.image = meme.memedImage
        
        return cell
    }

    
        
    

}
