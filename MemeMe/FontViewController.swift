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
    func updateFont(_ selector: FontSelector, shouldUseNewFont font: String)
}

class FontViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FontSelector {
    var fonts: [String] = UIFont.familyNames
    var font:String = ""
    var delegate : FontSelectorDelegate?
    @IBOutlet weak var topTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
       
    }

    // MARK: Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
      return fonts.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FontCell")!
        font = fonts[(indexPath as NSIndexPath).row]

        // Set the name and font
        cell.textLabel?.text = font
        let size = cell.textLabel?.font.pointSize ?? DefaultFontSize
        cell.textLabel?.font = UIFont(name: font, size: size)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
        
    {
        return true
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        font = fonts[(indexPath as NSIndexPath).row]
        delegate?.updateFont(self, shouldUseNewFont: font)
        dismiss(animated: true, completion: nil)
        
        
    }
 
}
