//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Lisa Litchfield on 9/7/16.
//  Copyright © 2016 Lisa Litchfield. All rights reserved.
//

import UIKit


class MemeTableViewController: UITableViewController, UINavigationControllerDelegate {
    fileprivate let reuseIdentifier = "MemeTableViewCell"
    var memes: [Meme]!
   // MARK: Navigation
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(MemeTableViewController.presentMemeEditor))
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadMemes), name: NSNotification.Name(rawValue: newMemeNotificationKey), object: nil)
       let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return memes.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        // Configure the cell...
        cell.imageView?.image = memes[(indexPath as NSIndexPath).item].memedImage

        return cell
    }
    
    func reloadMemes(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        self.tableView.reloadData()
    }

    func presentMemeEditor(){
        let editorViewController = storyboard?.instantiateViewController(withIdentifier: "MemeEditor") as! MemeEditorViewController
        self.navigationController?.present(editorViewController, animated: true, completion: nil)
        
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.beginUpdates()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.memes.remove(at: (indexPath as NSIndexPath).row)
            NotificationCenter.default.post(name: Notification.Name(rawValue: newMemeNotificationKey), object: self)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath){
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }

 

}
