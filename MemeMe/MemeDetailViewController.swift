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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
