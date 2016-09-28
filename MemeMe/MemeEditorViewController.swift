//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Lisa Litchfield on 8/29/16.
//  Copyright © 2016 Lisa Litchfield. All rights reserved.
//

import UIKit
import Photos
// Constants
struct Constants {

    static let newMemeNotificationKey = "LisaLitchfield.newMemeNotificationKey"
    static let DefaultFontSize = CGFloat(17.0) // only used to prevent unwrapping optionals with a ! (Just a compiler satisfier)
}

class MemeEditorViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,  FontSelectorDelegate {
    var sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Disable share button & camera button if device has no camera. 
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        if imagePickerView.image == nil {
            shareButton.isEnabled = false
            uncropButton.isEnabled = false
        }
        // set text attributes
        prepareTextField(topTextField)
        prepareTextField(bottomTextField)
        topTextField.textAlignment = NSTextAlignment.center
        bottomTextField.textAlignment = NSTextAlignment.center
        
        subscribeToKeyboardNotifications()
        
    }
    
    func prepareTextField(_ textField: UITextField){
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.black,
            NSForegroundColorAttributeName : UIColor.white,
            NSBackgroundColorAttributeName : UIColor.clear,
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : NSNumber.FloatLiteralType(-2)     ] as [String : Any]
        textField.defaultTextAttributes = memeTextAttributes
        textField.font = desiredFont
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        view.frame.origin.y = 0.0
        dismiss(animated: true, completion: nil)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! FontViewController
        
        if segue.identifier == "selectFont"{
            
            controller.delegate = self
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
   // MARK: Photo functions
    
    func imagePickerController(_ picker: UIImagePickerController,
                                 didFinishPickingMediaWithInfo info: [String : Any]){
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imagePickerView.image = image
            originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        
        shareButton.isEnabled = true
        uncropButton.isEnabled = true
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)

    }
    

    
    @IBAction func getPhoto(_ sender: UIBarButtonItem) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        let alertController = UIAlertController()
        alertController.title = "Not Authorized"
      
        
        if sender == cameraButton {
            let cameraPermission = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
            if  cameraPermission == .authorized {
                sourceType = UIImagePickerControllerSourceType.camera
                imagePickerController.sourceType = sourceType
                present(imagePickerController, animated: true, completion: nil)
            }
            else {
                alertController.message = "You must enable camera access for MemeMe in Settings-Privacy to use this feature"
                presentAlert(alertController: alertController)
            }
            
        }
        else {
            // sender = album
            sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePickerController.sourceType = sourceType
            let permission = Photos.PHPhotoLibrary.authorizationStatus()
            switch permission{
            case .authorized:
                present(imagePickerController, animated: true, completion: nil)
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({(status: PHAuthorizationStatus)-> Void in
                    if status == .authorized {
                        self.present(imagePickerController, animated: true, completion: nil)
                    }})
           case .denied:
                alertController.message = "You must enable photo album access for MemeMe in Settings-Privacy to use this feature"
                presentAlert(alertController: alertController)
            case .restricted:
                alertController.message = "You are not authorized to enable this feature"
                presentAlert(alertController: alertController)

            }
            
        }
        
    }
        
    func presentAlert(alertController: UIAlertController){
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            action in self.dismiss(animated: true, completion: nil)}
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func uncrop(_ sender: UIBarButtonItem) {
        imagePickerView.image = originalImage
    }

    // MARK: Text functions
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        editingBottomTextField = (textField.placeholder == DefaultBottomText)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func updateFont(_ selector: FontSelector, shouldUseNewFont font: String) {
        let size = topTextField.font?.pointSize ?? Constants.DefaultFontSize
        desiredFont = UIFont(name: font, size: size)!
    }
    
   // MARK: Keyboard notifications
    
    func subscribeToKeyboardNotifications(){

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillMove), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillMove), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {

        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    func keyboardWillMove(_ notification: Notification){
        if !editingBottomTextField{
            return
        }
        if notification.name == NSNotification.Name.UIKeyboardWillHide {

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
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // MARK: Meme functions
    
    func save()  {
        
        let topText = topTextField.text ?? ""
        let bottomText = bottomTextField.text ?? ""
        let meme = Meme(topText: topText, bottomText: bottomText, originalImage: imagePickerView.image!, memedImage: memedImage!)
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.newMemeNotificationKey), object: self)

    }
    
    func generateMemedImage()-> UIImage{
        hideToolbars(true)
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        hideToolbars(false)
        return memedImage
        
    }
    
    func hideToolbars(_ hide: Bool){
        navigationController?.setToolbarHidden(hide, animated: false)
        bottomToolbar.isHidden = hide
    }

    @IBAction func share(_ sender: UIBarButtonItem) {
        memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage!], applicationActivities: nil)
        
        activityController.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems, error) in
            // Return if cancelled             
            if (!completed) {
                return
            }
            //activity complete
            self.save()
            self.dismiss(animated: true, completion: nil)
            
        }
        present(activityController, animated: true, completion: nil)
     

    }
}

