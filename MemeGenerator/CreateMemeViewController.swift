//
//  CreateMemeViewController.swift
//  MemeGenerator
//
//  Created by Henrique Abreu on 29/06/2020.
//  Copyright © 2020 Henrique Abreu. All rights reserved.
//

import UIKit

struct Meme {
    let topText: String
    let bottomText:  String
    let originalImage: UIImage
    let memedImage: UIImage
}
class CreateMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // MARK: Outlets, vars and lets
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var textFieldTop: UITextField!
    @IBOutlet weak var textFieldBottom: UITextField!
    
    var activeTextField : UITextField? = nil
    var pickerHeightVisible: CGFloat!
    var meme: Meme?
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 32)!,
        NSAttributedString.Key.strokeWidth:  -4.5
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        setTextFieldMemeAtributes(textFieldTop)
        setTextFieldMemeAtributes(textFieldBottom)
        shareButton.isEnabled = false
        self.tabBarController?.tabBar.isHidden = true

    }
    
    func setTextFieldMemeAtributes(_ tf : UITextField){
        tf.defaultTextAttributes = memeTextAttributes
        tf.textAlignment = NSTextAlignment.center
        tf.delegate = self
    }
    
    //MARK: viewWill funcs
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    //MARK: Subscribers
    
    func subscribeToKeyboardNotifications() {

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    //MARK: Keyboard Funcs
    
    @objc func keyboardWillShow(_ notification:Notification) {

        var shouldMoveViewUp = false

        // if active text field is not nil
        if let activeTextField = activeTextField {

          let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY;
          
          let topOfKeyboard = self.view.frame.height - getKeyboardHeight(notification)

          // if the bottom of Textfield is below the top of keyboard, move up
          if bottomOfTextField > topOfKeyboard {
            shouldMoveViewUp = true
          }
        }
        if(shouldMoveViewUp){
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification){
        view.frame.origin.y = 0
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        //here we are checking the keyboard height to move the view so we can see the text
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }

    // MARK: Image Funcs
    //pickImage checks from photos app, pickImageFromCamera well, picks it from the camera baby
    @IBAction func pickImage(_ sender: Any) {
        wichPicker(.photoLibrary)
        
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        wichPicker(.camera)
        
     }
    
    func wichPicker(_ source : UIImagePickerController.SourceType){
        // changes the sourceType between camera and photos app
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        // if image is picked, share button in set to enabled
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    @IBAction func share(_ sender: Any) {
    }
    
    // MARK: TextField funcs
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //if textfields are using default values they should be clear
        if textField.text == "TOP" || textField.text == "BOTTOM"{
            textField.text = ""
        }
        //used to calculate if we should move the view or not
        self.activeTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
      self.activeTextField = nil
    }
    
    //MARK: MEME funcs
    
    @IBAction func saveAndShare() {
            // Create the meme
        
        
        //calling activityVC
        let shareController = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: [])
        
        shareController.completionWithItemsHandler = {(activity: UIActivity.ActivityType?, completed: Bool,  _: [Any]?, error: Error?) in
            if completed{
                self.meme = Meme(topText: self.textFieldTop.text!, bottomText: self.textFieldBottom.text!, originalImage: self.imageView.image!, memedImage: self.generateMemedImage())
                
                let object = UIApplication.shared.delegate
                let appDelegate = object as! AppDelegate
                appDelegate.memes.append(self.meme!)
            }

        }
        
        self.present(shareController, animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {

        // hide toolbar
        toolbar.isHidden = true
        navBar.accessibilityElementsHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //show toolbar
        toolbar.isHidden = false
        navBar.accessibilityElementsHidden = false
        
        return memedImage
    }

    
    
}

