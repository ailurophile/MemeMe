//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Lisa Litchfield on 9/7/16.
//  Copyright © 2016 Lisa Litchfield. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemeCell"


class MemeCollectionViewController: UICollectionViewController {
    var memes: [Meme]!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
     // MARK: - Navigation
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register for notifications

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reloadMemes), name: newMemeNotificationKey, object: nil)

        // create buttons and load data
//        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(MemeTableViewController.presentMemeEditor))

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = appDelegate.memes
        
        
    }
    
  override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    // set up flow layout
    configureFlowLayout(view.frame.size)
    
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        configureFlowLayout(size)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func presentMemeEditor(){
        let editorViewController = storyboard?.instantiateViewControllerWithIdentifier("MemeEditor") as! MemeEditorViewController
        self.navigationController?.presentViewController(editorViewController, animated: true, completion: nil)
        
    }
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
       
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MemeCollectionViewCell
    
        // Configure the cell
        cell.imageView?.image = memes[indexPath.item].memedImage
    
        return cell
    }
    
    func reloadMemes(){

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = appDelegate.memes
        self.collectionView?.reloadData()
    }
    
    func configureFlowLayout( size: CGSize){
        let space: CGFloat = 3.0
        let width = size.width
        let height = size.height
        var dimension = (width - (2*space))/3.0
        if width > height {
            dimension = (width - (5 * space))/6.0
        }

        flowLayout?.minimumLineSpacing = space
        flowLayout?.minimumInteritemSpacing = space
        flowLayout?.itemSize = CGSizeMake(dimension,dimension)
    }



}
