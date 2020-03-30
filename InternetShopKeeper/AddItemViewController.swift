//
//  AddItemViewController.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 28.02.20.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit
import CoreData

class AddItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate {
    // State for Bar button
    enum State {
        case addItem, editItem

        var leftButtonTitle: String {
            switch self {
            case .addItem: return "Скасувати"
            case .editItem: return "Назад"
            }
        }

        var rightButtonTitle: String {
            switch self {
            case .addItem: return "Готово"
            case .editItem: return "Змінити"
            }
        }
    }
    
    @IBOutlet weak var saveItemButtonOutlet: UIButton!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    @IBOutlet weak var tapGestureOutlet: UITapGestureRecognizer!
    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var titleItemTextField: UITextField!
    @IBOutlet weak var categoryItemTextField: UITextField!
    @IBOutlet weak var priceItemTextField: UITextField!
    @IBOutlet weak var amountItemTextField: UITextField!
    @IBOutlet weak var detailsItemTextView: UITextView!
//    @IBOutlet weak var detailsItemTextField: UITextField!
    @IBOutlet weak var newItemLabel: UILabel!
    @IBOutlet weak var enterImageItemLable: UILabel!
    @IBOutlet weak var enterTitleItemLable: UILabel!
    @IBOutlet weak var enterCategoryItemLable: UILabel!
    @IBOutlet weak var enterPriceItemLable: UILabel!
    @IBOutlet weak var enterAmountItemLabel: UILabel!
    @IBOutlet weak var enterDetailsItemLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
   // add sale View and sale Button and text fields of view
    @IBOutlet weak var saleButtonOutlet: UIButton!
    @IBOutlet weak var saleView: UIView!
    @IBOutlet weak var priceSaleViewTextFieldOutlet: UITextField!
    @IBOutlet weak var amountSaleViewTextFieldOutlet: UITextField!
    // Controller can additing and editing category item
    var currentState = State.addItem
    var isInEdit = false
    //Add imagePicker and pickerView
    var imagePicker = UIImagePickerController()
    var picker = UIPickerView()
    var categories = [Categories]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addImage.isHighlighted = true
        titleItemTextField.delegate = self
        categoryItemTextField.delegate = self
        priceItemTextField.delegate = self
        amountItemTextField.delegate = self
        detailsItemTextView.delegate = self
        picker.delegate = self
        categoryItemTextField.inputView = picker
        // Create placeholder to detailsItemTextView
        detailsItemTextView.text = "Введіть деталі свого товару"
        detailsItemTextView.textColor = UIColor.lightGray
        //configure saleView
        saleView.isHidden = true
        saleView.layer.cornerRadius = 10
        saleView.layer.shadowOpacity = 0.5
        saleView.layer.shadowColor = UIColor.black.cgColor
        saleView.layer.shadowOffset = .zero
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Categories.fetchRequest() as NSFetchRequest<Categories>
        do {
            categories = (try context.fetch(fetchRequest))

        } catch let error {
            print("Error \(error).")
        }
        saleButtonOutlet.isHidden = true
        // what state in what moment using
        if isInEdit {
            currentState = .editItem
            titleItemTextField.isUserInteractionEnabled = false
            categoryItemTextField.isUserInteractionEnabled = false
            priceItemTextField.isUserInteractionEnabled = false
            amountItemTextField.isUserInteractionEnabled = false
            detailsItemTextView.isUserInteractionEnabled = false
            detailsItemTextView.textColor = UIColor.black
            tapGestureOutlet.isEnabled = false
            saleButtonOutlet.isHidden = false

        }
        saveItemButtonOutlet.setTitle(currentState.rightButtonTitle, for: .normal)
        cancelButtonOutlet.setTitle(currentState.leftButtonTitle, for: .normal)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //configure textView that you can see placeholder
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Введіть деталі свого товару"
            textView.textColor = UIColor.lightGray
        }
    }
    //Deinit NotificationCenter
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isInEdit {
            view.endEditing(false)
        }
        view.endEditing(true)
    }
    @objc func keyboardWillAppear(notification: Notification) {
            guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
            let keyboardScreenEndFrame = keyboardValue.cgRectValue
            let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
            if notification.name == UIResponder.keyboardWillHideNotification {
                scrollView.contentInset = .zero
            } else {
                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
            }
            scrollView.scrollIndicatorInsets = scrollView.contentInset
        }

    @objc func keyboardWillHide(notification: Notification) {
            print(notification)
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
    
    // configure sale Button
    @IBAction func saleButtonAction(_ sender: UIButton) {
        print("Press Sale BUTTON")
        saleView.isHidden = false
        UIView.animate(withDuration: 0.5) {
                self.saleView.alpha = 1
            }
    }
    // configure cancel sale view button
    @IBAction func cancelSaleViewButtonAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            self.saleView.alpha = 0
        }) { (finished) in
            self.saleView.isHidden = finished
        }
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
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    imagePicker.dismiss(animated: true, completion: nil)

    guard let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        addImage.isHighlighted = false
        addImage.image = editedImage
        }
    // press button ADD
    @IBAction func addButtonAction(_ sender: UIButton) {
        print("Press ADD.")
        let titleItem = titleItemTextField.text ?? ""
        let category = categoryItemTextField.text ?? ""
        let priceItem = priceItemTextField.text ?? ""
        let amountItem = amountItemTextField.text ?? ""
        let detailsItem = detailsItemTextView.text ?? ""
        let imageItem = addImage.image?.pngData()
         // edit item and update coredata
        if titleItem == "" || category == "" || priceItem == "" || amountItem == "" || detailsItem == "" {
            let alert = UIAlertController(title: "Ви забули!", message: "Всі поля мають бути заповненими!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            if isInEdit {
                currentState = .editItem
                sender.isMultipleTouchEnabled = true
                sender.setTitle("Готово", for: .normal)
                titleItemTextField.isUserInteractionEnabled = true
                categoryItemTextField.isUserInteractionEnabled = true
                priceItemTextField.isUserInteractionEnabled = true
                amountItemTextField.isUserInteractionEnabled = true
                detailsItemTextView.isUserInteractionEnabled = true
                tapGestureOutlet.isEnabled = true
                newItemLabel.text = "Зміни деталі товару"
                enterImageItemLable.text = "Зміни фото твого товару"
            } else {
                //save all information of item to coreData
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let newItem = Item(context: context)
                newItem.titleItem = titleItem
                newItem.priceItem = priceItem
                newItem.categoryItem = category
                newItem.amountItem = amountItem
                newItem.detailsItem = detailsItem
                newItem.imageItem = imageItem
                do {
                    try context.save()
                } catch let error {
                    print("Error \(error).")
                }
                dismiss(animated: true, completion: nil)
            }
        }
    }
    // press button CANCEL
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        print("Press CANCEL.")
        dismiss(animated: true, completion: nil)
    }
        //dismiss imagePicker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    //Configurate pickerView in textfield with data fromCoreData
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count + 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard row > 0 else {
            return "Без категорії"
        }
        return categories[row - 1].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(categories)
        categoryItemTextField.text = row == 0 ?  "Без категорії" : categories[row - 1].name
        self.view.endEditing(false)
    }
    
}
// move to next textField
extension AddItemViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case titleItemTextField:
            priceItemTextField.becomeFirstResponder()
        case priceItemTextField:
            amountItemTextField.becomeFirstResponder()
        case amountItemTextField:
            detailsItemTextView.becomeFirstResponder()
        default: break
        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: textField.superview?.frame.origin.y ?? 0), animated: true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
}
