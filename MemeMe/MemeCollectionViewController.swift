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

        NotificationCenter.default.addObserver(self, selector: #selector(reloadMemes), name: NSNotification.Name(rawValue: Constants.newMemeNotificationKey), object: nil)

        // create buttons and load data
//        self.navigationItem.leftBarButtonItem = self.editButtonItem
//        self.installsStandardGestureForInteractiveMovement = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(MemeTableViewController.presentMemeEditor))

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        
        
    }
    
  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    // set up flow layout
    configureFlowLayout(view.frame.size)
    
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        configureFlowLayout(size)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func presentMemeEditor(){
        let editorViewController = storyboard?.instantiateViewController(withIdentifier: "MemeEditorNavigationController")
        navigationController?.present(editorViewController!, animated: true, completion: nil)
        
    }
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionViewCell
    
        // Configure the cell
        cell.imageView?.image = memes[(indexPath as NSIndexPath).item].memedImage
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath){
        let detailController = storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = memes[(indexPath as NSIndexPath).item]
        navigationController!.pushViewController(detailController, animated: true)

    }
    
    
    func reloadMemes(){

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        collectionView?.reloadData()
    }
    
    func configureFlowLayout( _ size: CGSize){
        let space: CGFloat = 3.0
        let width = size.width
        let height = size.height
        var dimension = (width - (2*space))/3.0
        if width > height {
            dimension = (width - (5 * space))/6.0
        }

        flowLayout?.minimumLineSpacing = space
        flowLayout?.minimumInteritemSpacing = space
        flowLayout?.itemSize = CGSize(width: dimension,height: dimension)
    }



}
