//
//  AddItemViewController.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 28.02.20.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit
import CoreData

class AddItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
   
    
    @IBOutlet weak var addImage: UIImageView!
    
    @IBOutlet weak var titleItemTextField: UITextField!
    @IBOutlet weak var categoryItemTextField: UITextField!
    @IBOutlet weak var priceItemTextField: UITextField!
    @IBOutlet weak var amountItemTextField: UITextField!
    @IBOutlet weak var detailsItemTextfield: UITextField!
    
    var imagePicker = UIImagePickerController()
    var picker = UIPickerView()
    var categories = CategoryTableViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        categoryItemTextField.inputView = picker
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //TODO - add animate imageView and
    // press on screen to add image of item
    
    @IBAction func addImageAction(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Зробити фото", style: .default, handler: { _ in
                    self.openCamera()
                }))
                
                alert.addAction(UIAlertAction(title: "Вибрати з галереї", style: .default, handler: { _ in
                    self.openGallary()
                }))
                
                alert.addAction(UIAlertAction(title: "Скасувати", style: .cancel, handler: nil))
                
                //If you want work actionsheet on ipad then you have to use popoverPresentationController to present the actionsheet, otherwise app will crash in iPad
        //        switch UIDevice.current.userInterfaceIdiom {
        //        case .pad:
        //            alert.popoverPresentationController?.sourceView = sender
        //            alert.popoverPresentationController?.sourceRect = sender.bounds
        //            alert.popoverPresentationController?.permittedArrowDirections = .up
        //        default:
        //            break
        //        }
                self.present(alert, animated: true, completion: nil)

    }
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Помилка", message: "У Вас немає камери", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func openGallary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
   
    // press button ADD
    @IBAction func AddButtonAction(_ sender: UIButton) {
        print("Press ADD.")
        
        //save all information of item to coreData
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newItem = Item(context: context)
        newItem.titleItem = titleItemTextField.text
        newItem.priceItem = priceItemTextField.text
        newItem.amountItem = amountItemTextField.text
        newItem.detailsItem = detailsItemTextfield.text
        newItem.imageItem = addImage.image?.pngData()
        do {
            try context.save()
        } catch let error {
            print("Не удалось сохранить из-за ошибки \(error).")
        }
        dismiss(animated: true, completion: nil)
    }
    // press button CANCEL
    @IBAction func CancelButtonAction(_ sender: UIButton) {
        print("Press CANCEL.")
        dismiss(animated: true, completion: nil)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imagePicker.dismiss(animated: true, completion: nil)

        guard let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        addImage.image = editedImage
            }
    //dismis imagePicker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories.categories[row].nameCategory
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryItemTextField.text = categories.categories[row].nameCategory
        self.view.endEditing(false)
    }

}
