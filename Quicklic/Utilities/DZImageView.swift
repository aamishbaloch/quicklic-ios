//
//  DZImageView.swift
//  ImageTester
//
//  Created by Danial Zahid on 1/21/16.
//  Copyright © 2016 Danial Zahid. All rights reserved.
//

import UIKit

@IBDesignable class DZImageView: UIImageView, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var parentController: UIViewController?
//    var url : URL

    @IBInspectable var placeholderImage: UIImage? {
        didSet {
            self.image = placeholderImage
        }
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }*/
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isUserInteractionEnabled = true
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.imageViewTapped(sender:)))
        self.addGestureRecognizer(singleTap)
        self.layer.cornerRadius = self.frame.height/2
        self.layer.masksToBounds = true
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    func imageViewTapped(sender: UITapGestureRecognizer){
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Upload from Camera", style: .default, handler: { (action) -> Void in
            self.selectFromCameraPressed()
        }))
        actionSheet.addAction(UIAlertAction(title: "Upload from Gallery", style: .default, handler: { (action) -> Void in
            self.selectFromGalleryPressed()
        }))
        actionSheet.popoverPresentationController?.sourceView = self.parentController?.view
        
        self.parentController?.present(actionSheet, animated: true, completion: nil)
    }

    func selectFromCameraPressed(){
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = true
            self.parentController?.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "No Camera detected", message: "No Camera was detected on this device", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) -> Void in
                
            }))
            self.parentController?.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    func selectFromGalleryPressed(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = true
            self.parentController?.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "Gallery ", message: "No Camera was detected on this device", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) -> Void in
                
            }))
            self.parentController?.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
//            self.contentMode = .scaleAspectFill
//        // self.image = pickedImage
//
//            self.image = pickedImage.resizeImageWith(newSize: CGSize(width: 200, height: 200))
//        }
//
//        picker.dismiss(animated: true, completion: nil)
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
//            self.image = pickedImage
            self.contentMode = .scaleAspectFill
            self.image = pickedImage.resizeImageWith(newSize: CGSize(width: 200, height: 200))
        }
        else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.contentMode = .scaleAspectFill
            self.image = image.resizeImageWith(newSize: CGSize(width: 200, height: 200))
        }
        picker.dismiss(animated: true, completion: nil);
    }
    

}
