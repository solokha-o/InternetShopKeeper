//
//  AddCategoryViewController.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 09.03.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit
import CoreData

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
    
    var ctwc = CategoryTableViewController()

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
        let category = addCategoryTextField.text ?? ""
        if isInEdit {
            // edit category and update coredata
            currentState = .editCategoryItem
            sender.isMultipleTouchEnabled = true
            sender.setTitle("Готово", for: .normal)
            addCategoryTextField.isUserInteractionEnabled = true
            enterCategoryLable.text = "Відредагуйте категорію товару"
            //update category to CoreData
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = Categories.fetchRequest() as NSFetchRequest<Categories>
            do {
                let updateContext = try context.fetch(fetchRequest)
                if updateContext.count > 0 {
                    let objUpdate =  updateContext[0] as NSManagedObject
                    objUpdate.setValue(category, forKey: "name")
                    do {
                        try context.save()
                    } catch let error {
                        print("Error \(error).")
                    }
                }
            } catch let error {
                    print("Error \(error).")
            }
        } else {
            //save category to CoreData
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let newCategory = Categories(context: context)
            newCategory.name = category
            do {
                try context.save()
            } catch let error {
                print("Error \(error).")
            }
            dismiss(animated: true, completion: nil)
        }
    }
    // press button CANCEL
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        print("Press CANCEL.")
        dismiss(animated: true, completion: nil)
    }
}
