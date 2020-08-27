//
//  MemeTableViewController.swift
//  MemeGenerator
//
//  Created by Henrique Abreu on 04/07/2020.
//  Copyright © 2020 Henrique Abreu. All rights reserved.
//

import CoreData
import UIKit

class MemeTableViewController: UITableViewController, DataControllerProtocol{
    
    var dataController: DataController?
    var memes: [Meme] = []
    
    // MARK: view funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        self.tabBarController?.tabBar.isHidden = false
        loadSavedImages()


    }
    
    //MARK: protocol funcs
    
    func loadSavedImages(){
                
        let fetchRequest : NSFetchRequest<Meme> = Meme.fetchRequest()
        
        guard let result = try? dataController?.viewContext.fetch(fetchRequest) else{return}
        memes = result
        print("saved data count:" + String(memes.count))
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setDataContoller(dataController: DataController) {
        self.dataController = dataController
    }

    //MARK: table funcs
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let meme = memes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeTableCell", for: indexPath) as! MemeTableCell
        
        cell.topText.text = meme.topText
        cell.bottomText.text = meme.bottomText
        let img = UIImage(data: meme.memedImage!, scale:1.0)
        cell.memeImageView.image = img
        
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
                viewDestination.dataController = dataController
                 
             }
         }
        if segue.identifier == "addSegue"{
            let viewDestination = segue.destination as! CreateMemeViewController
            viewDestination.edit = false
            viewDestination.dataController = dataController
        }
     }
}

