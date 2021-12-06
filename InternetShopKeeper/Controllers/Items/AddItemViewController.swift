//
//  AddItemViewController.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 28.02.20.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit
import CoreData

// protocol for create instance of ItemStruct
protocol AddItemViewControllerDelegate {
    func addItemViewController (_ addItemViewController: AddItemViewController, didAddItem item: ItemStruct)
}

class AddItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    // State for Bar button
    enum State {
        case addItem, editItem
        
        var leftButtonTitle: String {
            switch self {
                case .addItem: return "Скасувати".localized
                case .editItem: return "Назад".localized
            }
        }
        
        var rightButtonTitle: String {
            switch self {
                case .addItem: return "Готово".localized
                case .editItem: return "Змінити".localized
            }
        }
    }
    
    @IBOutlet weak var saveItemButtonOutlet: UIButton!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    @IBOutlet weak var clearPhotoButtonOutlet: UIButton!
    @IBOutlet weak var tapGestureOutlet: UITapGestureRecognizer!
    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var titleItemTextField: UITextField!
    @IBOutlet weak var categoryItemTextField: UITextField!
    @IBOutlet weak var priceItemTextField: UITextField!
    @IBOutlet weak var amountItemTextField: UITextField!
    @IBOutlet weak var detailsItemTextView: UITextView!
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
    //TODO: to change by scrollView
    @IBOutlet weak var saleStackView: UIStackView!
    @IBOutlet weak var saleStackViewLable: UILabel!
    @IBOutlet weak var incomePricesaleStackViewTextFieldOutlet: UITextField!
    @IBOutlet weak var amountsaleStackViewTextFieldOutlet: UITextField!
    @IBOutlet weak var cancelButtonsaleStackViewOutlet: UIButton!
    @IBOutlet weak var saveButtonsaleStackViewOutlet: UIButton!
    // create delegate of AddCategoryViewController
    var delegateItem : AddItemViewControllerDelegate?
    //create instance of CRUDModelCategory
    let crudModelCategory = CRUDModelCategory()
    //add instance for color app
    var color = [AppColor]()
    //create instance CRUDModelAppColor for read color from core date
    let crudModelAppColor = CRUDModelAppColor()
    //create instance of ItemStruct
    var item = ItemStruct(title: "", category: "", price: "", amount: "", details: "", image: UIImage(imageLiteralResourceName: "AddImage"), id: "", incomePrice: "", date: "")
    //create instance of SalesStruct
    var sale = SalesStruct(title: "", category: "", price: "", amount: "", image: UIImage(imageLiteralResourceName: "AddImage"), id: "", date: "")
    // Controller can additing and editing category item
    var currentState = State.addItem
    var isInEdit = false
    //Add imagePicker and pickerView
    var imagePicker = UIImagePickerController()
    var picker = UIPickerView()
    var categories = [Categories]()
    //create toolBar to pickerView
    let toolBar = UIToolbar()
    // add date property
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addImage.isHighlighted = true
        titleItemTextField.delegate = self
        categoryItemTextField.delegate = self
        priceItemTextField.delegate = self
        amountItemTextField.delegate = self
        detailsItemTextView.delegate = self
        //configure pickerView
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = .white
        picker.layer.shadowOpacity = 0.5
        picker.layer.shadowColor = UIColor.black.cgColor
        // configure toolBar to pickerView
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = .systemBlue
        toolBar.backgroundColor = .gray
        toolBar.sizeToFit()
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,target: self, action: #selector(self.cancelPicker))
        toolBar.setItems([cancelButtonItem, spaceButton, doneButtonItem], animated: true)
        toolBar.isUserInteractionEnabled = true
        categoryItemTextField.inputView = picker
        categoryItemTextField.inputAccessoryView = toolBar
        hideKeyboardTappedScreen()
        // Create placeholder to detailsItemTextView
        detailsItemTextView.text = "Введіть деталі свого товару".localized
        detailsItemTextView.textColor = UIColor.lightGray
        detailsItemTextView.layer.cornerRadius = 5
        //configure saleStackView
        saleStackView.isHidden = true
        saleStackView.alpha = 0.0
        // localize all objact
        newItemLabel.text = "Новий товар".localized
        enterImageItemLable.text = "Вибери фото товару".localized
        clearPhotoButtonOutlet.setTitle("Очистити фото".localized, for: .normal)
        enterTitleItemLable.text = "Назва товару".localized
        titleItemTextField.placeholder = "Введіть назву товару".localized
        enterCategoryItemLable.text = "Категорія товару".localized
        categoryItemTextField.placeholder = "Вибери категорію товару".localized
        enterPriceItemLable.text = "Ціна товару".localized
        priceItemTextField.placeholder = "Ціна".localized
        enterAmountItemLabel.text = "Кількість товару".localized
        amountItemTextField.placeholder = "Кількість".localized
        enterDetailsItemLabel.text = "Опис вашого товару".localized
        saleButtonOutlet.setTitle("Продати товар".localized, for: .normal)
        saleStackViewLable.text = "Ціна та кількість проданого товару".localized
        incomePricesaleStackViewTextFieldOutlet.placeholder = "Ціна".localized
        amountsaleStackViewTextFieldOutlet.placeholder = "Кількість".localized
        cancelButtonsaleStackViewOutlet.setTitle("Скасувати".localized, for: .normal)
        saveButtonsaleStackViewOutlet.setTitle("Готово".localized, for: .normal)
        // get notification center to receive
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: .colorNotificationKey, object: nil)
        // create NotificationCenter for keyboardWillShowNotification and keyboardWillHideNotification
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        // formate of date
        dateFormatter.dateFormat = "dd.MM.yy"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // get category from coreData to piker
        categories = crudModelCategory.fetchCategory(categories: categories)
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
            clearPhotoButtonOutlet.isHidden = true
        }
        saveItemButtonOutlet.setTitle(currentState.rightButtonTitle, for: .normal)
        cancelButtonOutlet.setTitle(currentState.leftButtonTitle, for: .normal)
        setupColorApp()
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
            textView.text = "Введіть деталі свого товару".localized
            textView.textColor = UIColor.lightGray
        }
    }
    //    //Deinit NotificationCenter
    //    deinit {
    //        NotificationCenter.default.removeObserver(self)
    //    }
    // configure touchesBegan for state isInEdit
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isInEdit {
            view.endEditing(false)
        }
        view.endEditing(true)
    }
    // configure keyboard to scrollView
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
    // press on screen to add image of item
    @IBAction func addImageAction(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Зробити фото".localized, style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Вибрати з галереї".localized, style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction(title: "Скасувати".localized, style: .cancel, handler: nil))
        
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
        incomePricesaleStackViewTextFieldOutlet.text = ""
        amountsaleStackViewTextFieldOutlet.text = ""
        UIView.animate(withDuration: 0.5) {
            self.saleStackView.isHidden = false
            self.saleStackView.alpha = 1
        }
    }
    // configure clear button photo
    @IBAction func clearPhotoButtonAction(_ sender: UIButton) {
        UIImageView.animate(withDuration: 1.0) {
            self.addImage.image = self.addImage.highlightedImage
        }
        tapGestureOutlet.isEnabled = true
    }
    // configure press button SAVE of saleStackView
    @IBAction func savesaleStackViewButtonAction(_ sender: UIButton) {
        let incomePrice = incomePricesaleStackViewTextFieldOutlet.text ?? ""
        let saleAmount = amountsaleStackViewTextFieldOutlet.text ?? ""
        item.incomePrice = String((Int(incomePrice) ?? 0) * (Int(saleAmount) ?? 0))
        let amount = amountItemTextField.text ?? ""
        let newAmount = (Int(amount) ?? 0) - (Int(saleAmount) ?? 0)
        if newAmount < 0 {
            let alert = UIAlertController(title: "Помилка!".localized, message: "Перевірте кількість проданих товарів! Кількість не має бути більшою за ту що у Вас є в наявності".localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            item.amount = String(newAmount)
            amountItemTextField.text = item.amount
            if incomePrice == "" || saleAmount == "" {
                let alert = UIAlertController(title: "Ви забули!".localized, message: "Всі поля мають бути заповненими!".localized, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                // delegate to ItemTableViewController
                item.title = titleItemTextField.text ?? ""
                item.category = categoryItemTextField.text ?? ""
                item.price = priceItemTextField.text ?? ""
                item.amount = amountItemTextField.text ?? ""
                item.details = detailsItemTextView.text
                item.image = addImage.image ?? addImage.highlightedImage!
                delegateItem?.addItemViewController(self, didAddItem: item)
                // pass sale to SalesTableViewController
                sale.title = titleItemTextField.text ?? ""
                sale.category = categoryItemTextField.text ?? ""
                sale.price = incomePricesaleStackViewTextFieldOutlet.text ?? ""
                sale.amount = amountsaleStackViewTextFieldOutlet.text ?? ""
                sale.image = addImage.image ?? addImage.highlightedImage!
                sale.id = UUID() .uuidString
                sale.date = dateFormatter.string(from: currentDate)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                guard let salesVC = storyboard.instantiateViewController(identifier: "SalesTableViewController") as? SalesTableViewController else { return }
                salesVC.appendSale(sale: sale)
                // configure hide saveView
                UIView.animate(withDuration: 0.5) {
                    self.saleStackView.alpha = 0
                    self.saleStackView.isHidden = true
                }
                dismiss(animated: true, completion: nil)
            }
        }
    }
    // configure cancel button of saleStackView
    @IBAction func cancelsaleStackViewButtonAction(_ sender: UIButton) {
        // configure hide saveView
        UIView.animate(withDuration: 0.5) {
            self.saleStackView.alpha = 0
            self.saleStackView.isHidden = true
        }
    }
    // configure open camera and add photo
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Помилка".localized, message: "У Вас немає камери!".localized, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    // configure open gallery and add photo
    func openGallery(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    // configure image what will chose after finish imagePickerController
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        guard let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        addImage.isHighlighted = false
        addImage.image = editedImage
        tapGestureOutlet.isEnabled = false
    }
    // press button ADD
    @IBAction func addButtonAction(_ sender: UIButton) {
        print("Press ADD.")
        // configure button to save item or edit item
        switch isInEdit {
            case false:
                item.title = titleItemTextField.text ?? ""
                item.category = categoryItemTextField.text ?? ""
                item.price = priceItemTextField.text ?? ""
                item.amount = amountItemTextField.text ?? ""
                item.details = detailsItemTextView.text ?? ""
                item.id = UUID() .uuidString
                item.image = addImage.image ?? addImage.highlightedImage!
                item.date = dateFormatter.string(from: currentDate)
                if item.title == "" || item.category == "" || item.price == "" || item.amount == "" || item.details == "" {
                    let alert = UIAlertController(title: "Ви забули!".localized, message: "Всі поля мають бути заповненими!".localized, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    delegateItem?.addItemViewController(self, didAddItem: item)
                    dismiss(animated: true, completion: nil)
                }
            case true:
                currentState = .editItem
                UIButton.animate(withDuration: 0.5) {
                    self.clearPhotoButtonOutlet.isHidden = false
                }
                sender.isMultipleTouchEnabled = true
                sender.setTitle("Готово".localized, for: .normal)
                titleItemTextField.isUserInteractionEnabled = true
                categoryItemTextField.isUserInteractionEnabled = true
                priceItemTextField.isUserInteractionEnabled = true
                amountItemTextField.isUserInteractionEnabled = true
                detailsItemTextView.isUserInteractionEnabled = true
                tapGestureOutlet.isEnabled = false
                saleButtonOutlet.isHidden = true
                newItemLabel.text = "Зміни деталі товару".localized
                enterImageItemLable.text = "Зміни фото твого товару".localized
                if sender.titleLabel?.text == "Готово".localized{
                    item.title = titleItemTextField.text ?? ""
                    item.category = categoryItemTextField.text ?? ""
                    item.price = priceItemTextField.text ?? ""
                    item.amount = amountItemTextField.text ?? ""
                    item.details = detailsItemTextView.text ?? ""
                    item.image = addImage.image ?? addImage.highlightedImage!
                    if item.title == "" || item.category == "" || item.price == "" || item.amount == "" || item.details == "" {
                        let alert = UIAlertController(title: "Ви забули!".localized, message: "Всі поля мають бути заповненими!".localized, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        delegateItem?.addItemViewController(self, didAddItem: item)
                        dismiss(animated: true, completion: nil)
                        print("Delegate " + item.id)
                    }
                }
        }
    }
    // configure press button CANCEL
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        print("Press CANCEL.")
        dismiss(animated: true, completion: nil)
    }
    //dismiss imagePicker to press cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    //Configurate pickerView in textfield with data from CategoryTableViewController
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count + 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard row > 0 else {
            return "Без категорії".localized
        }
        return categories[row - 1].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(categories)
        categoryItemTextField.text = row == 0 ?  "Без категорії".localized : categories[row - 1].name
    }
    // action done and cancel pickerView
    @objc func donePicker () {
        categoryItemTextField.resignFirstResponder()
    }
    @objc func cancelPicker() {
        categoryItemTextField.resignFirstResponder()
        categoryItemTextField.text = ""
    }
    // function call to change color view
    @objc func notificationReceived(_ notification: Notification) {
        guard let color = notification.userInfo?["color"] as? UIColor else { return }
        self.view.backgroundColor = color
    }
    // setup color app from core data
    func setupColorApp() {
        color = crudModelAppColor.fetchColor(color: color)
        let uiColor = UIColor.uiColorFromString(string: color[0].color ?? ".systemOrange")
        self.view.backgroundColor = uiColor
    }
}
// move to next textField
extension AddItemViewController: UITextFieldDelegate, UITextViewDelegate {
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
}
//hide keyboard when tap on screen
extension UIViewController {
    func hideKeyboardTappedScreen() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
