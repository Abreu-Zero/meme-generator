//
//  MemeCollectionViewController.swift
//  MemeGenerator
//
//  Created by Henrique Abreu on 04/07/2020.
//  Copyright © 2020 Henrique Abreu. All rights reserved.
//

import UIKit
import CoreData

class MemeCollectionViewController: UICollectionViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // getting meme data from appDelegate
    var memes: [Meme] = []
    var dataController: DataController?
    
    // MARK: view funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0

        //setting flowLayout properties
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        loadSavedImages()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //reloading data and seting tabbar to appear again
        self.tabBarController?.tabBar.isHidden = false
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
    
    // MARK: col funcs
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
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