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
    
    var dataController: DataController?
    // getting meme data from appDelegate
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    // MARK: view funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        self.tabBarController?.tabBar.isHidden = false

    }

    //MARK: table funcs
    
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
    
    //MARK: segue funcs

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "tableSegue"{
             
             if let indexPath = tableView.indexPathForSelectedRow{
                 let memeS = self.memes[indexPath.row]
                 let viewDestination = segue.destination as! CreateMemeViewController
                 viewDestination.meme = memeS
                 viewDestination.edit = true
                 
             }
         }
     }
    
        
    

}
