//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Lisa Litchfield on 8/29/16.
//  Copyright © 2016 Lisa Litchfield. All rights reserved.
//

import UIKit
// globals
let newMemeNotificationKey = "LisaLitchfield.newMemeNotificationKey"
let DefaultFontSize = CGFloat(17.0) // only used to prevent unwrapping optionals with a ! (Just a compiler satisfier)

class MemeEditorViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,  FontSelectorDelegate {
    var sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.Camera
    let DefaultTopText = "TOP"
    let DefaultBottomText = "BOTTOM"
    var editingBottomTextField: Bool = false
    var viewShift: CGFloat = 0.0
    var memedImage: UIImage?
    var desiredFont: UIFont = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
    var originalImage: UIImage?
    
    

    
    // MARK: outlets
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var uncropButton: UIBarButtonItem!
    
    // MARK: Navigation
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Disable share button & camera button if device has no camera. 
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        if imagePickerView.image == nil {
            shareButton.enabled = false
            uncropButton.enabled = false
        }
        // set text attributes
        prepareTextField(topTextField)
        prepareTextField(bottomTextField)
        
        subscribeToKeyboardNotifications()
        navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    func prepareTextField(textField: UITextField){
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSBackgroundColorAttributeName : UIColor.clearColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : NSNumber.FloatLiteralType(-2)     ]
        textField.defaultTextAttributes = memeTextAttributes
        textField.font = desiredFont
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
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController as! FontViewController
        
        if segue.identifier == "selectFont"{
            
            controller.delegate = self
        }
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
   // MARK: Photo functions
    func imagePickerController(picker: UIImagePickerController,
                                 didFinishPickingMediaWithInfo info: [String : AnyObject]){
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imagePickerView.image = image
        }
        originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        shareButton.enabled = true
        uncropButton.enabled = true
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
        imagePickerController.allowsEditing = true
        presentViewController(imagePickerController, animated: true, completion: nil)
        

    }
    
    @IBAction func uncropImage(sender: UIBarButtonItem) {
        if (originalImage != nil) {
            imagePickerView.image = originalImage
        }
    }

    // MARK: Text functions
    
    func textFieldDidBeginEditing(textField: UITextField) {
        editingBottomTextField = (textField.placeholder == DefaultBottomText)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    
    func updateFont(selector: FontSelector, shouldUseNewFont font: String) {
        let size = topTextField.font?.pointSize ?? DefaultFontSize
        desiredFont = UIFont(name: font, size: size)!

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
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        NSNotificationCenter.defaultCenter().postNotificationName(newMemeNotificationKey, object: self)
        print(appDelegate.memes.count)
        for each in appDelegate.memes{
            print(each.topText,each.bottomText,each.memedImage)
        } 
//        dismissViewControllerAnimated(true, completion: nil)

    }
    
    func generateMemedImage()-> UIImage{
        hideToolbars(true)
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame,
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
        activityController.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:[AnyObject]?, error: NSError?) in
            // Return if cancelled             
            if (!completed) {
                return
            }
            //activity complete
            self.save()
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
        presentViewController(activityController, animated: true, completion: nil)
//        dismissViewControllerAnimated(true, completion: nil)
        
    }
}

