//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Lisa Litchfield on 9/7/16.
//  Copyright © 2016 Lisa Litchfield. All rights reserved.
//

import UIKit


class MemeTableViewController: UITableViewController, UINavigationControllerDelegate {
    private let reuseIdentifier = "MemeTableViewCell"
    var memes: [Meme]!
   // MARK: Navigation
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(MemeTableViewController.presentMemeEditor))
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reloadMemes), name: newMemeNotificationKey, object: nil)
       let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = appDelegate.memes

    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return memes.count
    }

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)

        // Configure the cell...
        cell.imageView?.image = memes[indexPath.item].memedImage

        return cell
    }
    
    func reloadMemes(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = appDelegate.memes
        self.tableView.reloadData()
    }

    func presentMemeEditor(){
        let editorViewController = storyboard?.instantiateViewControllerWithIdentifier("MemeEditor") as! MemeEditorViewController
        self.navigationController?.presentViewController(editorViewController, animated: true, completion: nil)
        
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.beginUpdates()
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.memes.removeAtIndex(indexPath.row)
            reloadMemes()
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.endUpdates()
        }
    }
 

}
