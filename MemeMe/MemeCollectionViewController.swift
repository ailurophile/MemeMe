//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Lisa Litchfield on 9/7/16.
//  Copyright © 2016 Lisa Litchfield. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemeCell"


class MemeCollectionViewController: UICollectionViewController,UINavigationControllerDelegate {
    var memes: [Meme]!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
     // MARK: - Navigation
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes & notifications
//        self.collectionView!.registerClass(MemeCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reloadMemes), name: newMemeNotificationKey, object: nil)

        // create buttons and load data
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
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
        print("adjusting to width: \(size.width) height: \(size.height)")
        configureFlowLayout(size)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: newMemeNotificationKey, object: nil)
        
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
        print("top text of memed image: \(memes[indexPath.item].topText)")
    
        return cell
    }
    
    func reloadMemes(){
        print("collection view got notification")
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
        

        print( "width = \(width) height = \(height) dimension = \(dimension)")

        
        
        flowLayout?.minimumLineSpacing = space
        flowLayout?.minimumInteritemSpacing = space
        flowLayout?.itemSize = CGSizeMake(dimension,dimension)
    }


    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        navigationController.viewWillAppear(animated)
    }

}
