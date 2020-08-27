//
//  MemeCollectionViewController.swift
//  MemeGenerator
//
//  Created by Henrique Abreu on 04/07/2020.
//  Copyright © 2020 Henrique Abreu. All rights reserved.
//

import UIKit
import CoreData

class MemeCollectionViewController: UICollectionViewController, DataControllerProtocol {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme] = []
    var dataController: DataController?
    
    // MARK: view funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //reloading data and seting tabbar to appear again
        self.tabBarController?.tabBar.isHidden = false
        loadSavedImages()
        collectionView.reloadData()
    }
    
    //MARK: load memes
        
    func loadSavedImages(){
                
        let fetchRequest : NSFetchRequest<Meme> = Meme.fetchRequest()
        
        guard let result = try? dataController?.viewContext.fetch(fetchRequest) else{return}
        memes = result
        print("saved data count:" + String(memes.count))
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func setDataContoller(dataController: DataController) {
        self.dataController = dataController
    }
    
    // MARK: col funcs
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //sets the cell using memes data

        let meme = memes[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCollectionCell", for: indexPath) as! MemeCollectionCell
         let img = UIImage(data: meme.memedImage!, scale:1.0)
        cell.memeImageView.image = img
        
        return cell
    }
    
    // MARK: segue funcs
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "collectionSegue"{
            // using segue to set the meme in the editor VC,
            //if old meme was picked, edit = true
             
             if let cell = sender as? UICollectionViewCell{
                
                let indexPath = self.collectionView!.indexPath(for: cell)
                let memeS = self.memes[indexPath!.row]
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
