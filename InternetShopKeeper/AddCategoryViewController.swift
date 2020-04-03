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
            case .addCategoryItem: return "Скасувати"
            case .editCategoryItem: return "Назад"
            }
        }

        var rightButtonTitle: String {
            switch self {
            case .addCategoryItem: return "Готово"
            case .editCategoryItem: return "Змінити"
            }
        }
    }
    @IBOutlet weak var saveCategoryButtonOutlet: UIButton!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    @IBOutlet weak var newCategoryLable: UILabel!
    @IBOutlet weak var enterCategoryLable: UILabel!
    @IBOutlet weak var addCategoryTextField: UITextField!
    
    // create delegate of AddCategoryViewController
    var delegate : AddCategoryViewControllerDelegate?
    //create instance of CategoryStruct
    var category = CategoryStruct(name: "", id: "")
    // Controller can additing and editing category item
    var currentState = State.addCategoryItem
    var isInEdit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                let alert = UIAlertController(title: "Ви забули!", message: "Поле має бути заповненим!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                 delegate?.addCategoryViewController(self, didAddCategory: category)
            }
            dismiss(animated: true, completion: nil)
        case true:
            currentState = .editCategoryItem
            sender.setTitle("Готово", for: .normal)
            addCategoryTextField.isUserInteractionEnabled = true
            enterCategoryLable.text = "Відредагуйте категорію товару"
            if sender.titleLabel?.text == "Готово" {
                category.name = addCategoryTextField.text ?? ""
                print(category.id)
                if category.name == "" {
                    let alert = UIAlertController(title: "Ви забули!", message: "Поле має бути заповненим!", preferredStyle: .alert)
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
}
