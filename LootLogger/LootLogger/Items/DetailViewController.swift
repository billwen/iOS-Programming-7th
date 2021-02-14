//
//  DetailViewController.swift
//  LootLogger
//
//  Created by Gang Wen on 2021-02-11.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var _nameField: UITextField!
    
    @IBOutlet var _snField: UITextField!
    
    @IBOutlet var _valueField: UITextField!
    
    @IBOutlet var _dateField: UILabel!
    
    @IBOutlet var _imageView: UIImageView!
    
    var _item: Item! {
        didSet {
            navigationItem.title = _item.name
        }
    }
    
    var _imageStore: ImageStore!
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return formatter
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self._nameField.text = self._item.name
        self._snField.text = self._item.serialNumber
        /*
        self._valueField.text = "\(self._item.valueInDollars)"
        self._dateField.text = "\(self._item.dateCreated)"
 */
        self._valueField.text = numberFormatter.string(from: NSNumber(value: self._item.valueInDollars))
        self._dateField.text = dateFormatter.string(from: self._item.dateCreated)
        
        // Get the item key
        let key = self._item.itemKey
        
        // If there is an associated image with the item, display it on the image view
        let imageToDisplay = self._imageStore.image(forKey: key)
        self._imageView.image = imageToDisplay
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // clear first reponder
        view.endEditing(true)
        
        // Save changes to item
        self._item.name = self._nameField.text ?? " "
        self._item.serialNumber = self._snField.text ?? " "
        
        if let valueText = self._valueField.text,
           let value = numberFormatter.number(from: valueText) {
            self._item.valueInDollars = value.intValue
        } else {
            self._item.valueInDollars = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func imagePicker(for sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        return imagePicker
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        print("background tapped")
        view.endEditing(true)
    }
    
    @IBAction func choosePhotoSource(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let camerAction = UIAlertAction(title: "Camera", style: .default) { _ in
                print("Present camera")
                let picker = self.imagePicker(for: .camera)
                self.present(picker, animated: true, completion: nil)
            }
            alertController.addAction(camerAction)
        }

        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
            print("Present photo library")
            let picker = self.imagePicker(for: .photoLibrary)
            picker.modalPresentationStyle = .popover
            picker.popoverPresentationController?.barButtonItem = sender
            self.present(picker, animated: true, completion: nil)
        }
        alertController.addAction(photoLibraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Image Picker's Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // Get picked image from info dictionary
        let image = info[.originalImage] as! UIImage
        
        // Store the image in the ImageStore for the item's key
        self._imageStore.setImage(image, forKey: self._item.itemKey)
        
        // put that image on the screen in the image view
        self._imageView.image = image
        
        // Take image picker off the screen - you must call this dismiss method
        dismiss(animated: true, completion: nil)
    }
    
}
