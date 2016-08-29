//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Lisa Litchfield on 8/29/16.
//  Copyright © 2016 Lisa Litchfield. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.Camera
    let DefaultTopText = "TOP"
    let DefaultBottomText = "BOTTOM"
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSBackgroundColorAttributeName : UIColor.clearColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : NSNumber.FloatLiteralType(-2)     ]
    

    // MARK: outlets
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
        
        // Disable share button & camera button if device has no camera.
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        if imagePickerView.image == nil {
            shareButton.enabled = false
        }
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(sender: AnyObject) {
        print("dismissing view controller")
        topTextField.text = nil
        bottomTextField.text = nil
        imagePickerView.image = nil
    }
   // MARK: Photo functions
    func imagePickerController(picker: UIImagePickerController,
                                 didFinishPickingMediaWithInfo info: [String : AnyObject]){
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        }
        shareButton.enabled = true
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        dismissViewControllerAnimated(true, completion: nil)

    }
    @IBAction func getPhoto(sender: UIBarButtonItem) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        
        if sender.tag == 1 {
            sourceType = UIImagePickerControllerSourceType.Camera
        }
        else {
            sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        imagePickerController.sourceType = sourceType
        presentViewController(imagePickerController, animated: true, completion: nil)
        

    }
    
    @IBAction func share(sender: UIBarButtonItem) {
        print("share button selected")
    }

    // MARK: Text functions

    func textFieldDidBeginEditing(textField: UITextField) {
        print(textField.hasText(),textField.description, textField.placeholder)  }

}

