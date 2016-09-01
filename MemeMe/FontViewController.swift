//
//  FontViewController.swift
//  MemeMe
//
//  Created by Lisa Litchfield on 8/31/16.
//  Copyright © 2016 Lisa Litchfield. All rights reserved.
//

import Foundation
import UIKit

class FontViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var fonts: [String] = UIFont.familyNames()
@IBOutlet weak var topTextField: UITextField!
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
       
    }

    // MARK: Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
      return self.fonts.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FontCell")!
        let font = self.fonts[indexPath.row]

        // Set the name and font
        cell.textLabel?.text = font
        let size = cell.textLabel?.font.pointSize ?? 17.0
        cell.textLabel?.font = UIFont(name: font, size: size)
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
        
    {
        return true
    }
  
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let font = fonts[indexPath.row]
        print("\(font) selected")
        self.navigationController?.popViewControllerAnimated(true)
        
        
    }
 
}