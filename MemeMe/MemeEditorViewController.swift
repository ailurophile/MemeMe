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
    var editingBottomTextField: Bool = false
    var viewShift: CGFloat = 0.0
    var memedImage: UIImage?
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
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    // MARK: Navigation
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
        
        // Disable share button & camera button if device has no camera.
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        if imagePickerView.image == nil {
            shareButton.enabled = false
        }
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        subscribeToKeyboardNotifications()
        
    }

    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func cancel(sender: AnyObject) {
        topTextField.text = nil
        bottomTextField.text = nil
        imagePickerView.image = nil
        view.frame.origin.y = 0.0
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
    

    // MARK: Text functions

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    
    func subscribeToKeyboardNotifications(){

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillMove), name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillMove), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    func unsubscribeFromKeyboardNotifications() {

        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    func keyboardWillMove(notification: NSNotification){
        if !editingBottomTextField{
            return
        }
        if notification.name == UIKeyboardWillHideNotification {

            viewShift = 0.0
            view.frame.origin.y = viewShift

        }
        else {

            let height = getKeyboardHeight(notification)
            if height != viewShift{
                viewShift = height
                view.frame.origin.y = viewShift*(-1.0)

            }
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    // MARK: Meme functions
    func save()  {
        
        let topText = topTextField.text ?? ""
        let bottomText = bottomTextField.text ?? ""
        let meme = Meme(topText: topText, bottomText: bottomText, originalImage: imagePickerView.image!, memedImage: memedImage!)
    }
    
    func generateMemedImage()-> UIImage{
        hideToolbars(true)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        hideToolbars(false)
        return memedImage
        
        
    }
    func hideToolbars(hide: Bool){
        topToolbar.hidden = hide
        bottomToolbar.hidden = hide
    }

    @IBAction func share(sender: UIBarButtonItem) {
        memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage!], applicationActivities: nil)
        self.presentViewController(activityController, animated: true, completion: save)
        
    }
}

