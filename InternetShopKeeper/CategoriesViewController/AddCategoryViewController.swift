//
//  AddCategoryViewController.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 09.03.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit
import CoreData

// protocol for create instance of CategoryStruct
protocol AddCategoryViewControllerDelegate {
    func addCategoryViewController (_ addCategoryViewController: AddCategoryViewController, didAddCategory category: CategoryStruct)
}

class AddCategoryViewController: UIViewController {
// State for Bar button
    enum State {
        case addCategoryItem, editCategoryItem

        var leftButtonTitle: String {
            switch self {
            case .addCategoryItem: return "Скасувати".localized
            case .editCategoryItem: return "Назад".localized
            }
        }

        var rightButtonTitle: String {
            switch self {
            case .addCategoryItem: return "Готово".localized
            case .editCategoryItem: return "Змінити".localized
            }
        }
    }
    @IBOutlet weak var saveCategoryButtonOutlet: UIButton!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    @IBOutlet weak var newCategoryLable: UILabel!
    @IBOutlet weak var enterCategoryLable: UILabel!
    @IBOutlet weak var addCategoryTextField: UITextField!
    
    //add instance for color app
    var color = [AppColor]()
    //create instance CRUDModelAppColor for read color from core date
    let crudModelAppColor = CRUDModelAppColor()
    // create delegate of AddCategoryViewController
    var delegate : AddCategoryViewControllerDelegate?
    //create instance of CategoryStruct
    var category = CategoryStruct(name: "", id: "")
    // Controller can additing and editing category item
    var currentState = State.addCategoryItem
    var isInEdit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newCategoryLable.text = "Нова категорія".localized
        enterCategoryLable.text = "Введи категорію товару".localized
        addCategoryTextField.placeholder = "Категорія товару".localized
        hideKeyboardTappedScreen()
        // get notification center to receive
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: .colorNotificationKey, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // what state in what moment using
        if isInEdit {
            currentState = .editCategoryItem
            addCategoryTextField.isUserInteractionEnabled = false
        }
        saveCategoryButtonOutlet.setTitle(currentState.rightButtonTitle, for: .normal)
        cancelButtonOutlet.setTitle(currentState.leftButtonTitle, for: .normal)
        setupColorApp()
    }
    // press button ADD
    @IBAction func saveCategoryButtonAction(_ sender: UIButton) {
        print("Press ADD")
        // configure button to save category or edit category
        switch isInEdit {
        case false:
            category.name = addCategoryTextField.text ?? ""
            category.id =  UUID() .uuidString
            print(category.id)
            if category.name == "" {
                let alert = UIAlertController(title: "Ви забули!".localized, message: "Поле має бути заповненим!".localized, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                delegate?.addCategoryViewController(self, didAddCategory: category)
                dismiss(animated: true, completion: nil)
            }
        case true:
            currentState = .editCategoryItem
            sender.setTitle("Готово".localized, for: .normal)
            addCategoryTextField.isUserInteractionEnabled = true
            enterCategoryLable.text = "Відредагуйте категорію товару".localized
            if sender.titleLabel?.text == "Готово".localized {
                category.name = addCategoryTextField.text ?? ""
                print(category.id)
                if category.name == "" {
                    let alert = UIAlertController(title: "Ви забули!".localized, message: "Поле має бути заповненим!".localized, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    delegate?.addCategoryViewController(self, didAddCategory: category)
                    print(category)
                    dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    // press button CANCEL
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        print("Press CANCEL.")
        dismiss(animated: true, completion: nil)
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
