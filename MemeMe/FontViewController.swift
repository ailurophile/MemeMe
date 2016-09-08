//
//  FontViewController.swift
//  MemeMe
//
//  Created by Lisa Litchfield on 8/31/16.
//  Copyright © 2016 Lisa Litchfield. All rights reserved.
//

import Foundation
import UIKit

protocol FontSelector {
    var font: String {get set}
}

protocol FontSelectorDelegate {
    func updateFont(selector: FontSelector, shouldUseNewFont font: String)
}

class FontViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FontSelector {
    var fonts: [String] = UIFont.familyNames()
    var font:String = ""
    var delegate : FontSelectorDelegate?
    @IBOutlet weak var topTextField: UITextField!
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
       
    }

    // MARK: Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
      return fonts.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FontCell")!
        font = fonts[indexPath.row]

        // Set the name and font
        cell.textLabel?.text = font
        let size = cell.textLabel?.font.pointSize ?? DefaultFontSize
        cell.textLabel?.font = UIFont(name: font, size: size)
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
        
    {
        return true
    }
  
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        font = fonts[indexPath.row]
        delegate?.updateFont(self, shouldUseNewFont: font)
        
//        navigationController?.popViewControllerAnimated(true)
        dismissViewControllerAnimated(true, completion: nil)
        
        
    }
 
}