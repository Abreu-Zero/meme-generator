//
//  MemeCollectionViewController.swift
//  MemeGenerator
//
//  Created by Henrique Abreu on 04/07/2020.
//  Copyright © 2020 Henrique Abreu. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let space:CGFloat = 3.0
            let dimension = (view.frame.size.width - (2 * space)) / 3.0

            flowLayout.minimumInteritemSpacing = space
            flowLayout.minimumLineSpacing = space
            flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        collectionView.reloadData()


    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let meme = memes[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCollectionCell", for: indexPath) as! MemeCollectionCell

        cell.memeImageView.image = meme.memedImage
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "collectionSegue"{
             
             if let cell = sender as? UICollectionViewCell{
                
                let indexPath = self.collectionView!.indexPath(for: cell)
                let memeS = self.memes[indexPath!.row]
                let viewDestination = segue.destination as! CreateMemeViewController
                viewDestination.meme = memeS
                viewDestination.edit = true
                 
             }
         }
        
        
     }
    
    

    

}
