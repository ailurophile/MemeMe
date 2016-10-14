//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Lisa Litchfield on 9/15/16.
//  Copyright © 2016 Lisa Litchfield. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var memeDetail: UIImageView!
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeDetail.image =  meme.memedImage
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(MemeDetailViewController.shareAgain))
    }
    
    @IBAction func shareAgain(_ sender: UIBarButtonItem) {
        
        let activityController = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
        
        
    }
    

}
