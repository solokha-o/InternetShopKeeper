//
//  AddCategoryViewController.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 09.03.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit
import CoreData
protocol AddCategoryViewControllerDelegate {
    func addCategoryViewController (_ addCategoryViewController: AddCategoryViewController, didAddCategory category: CategoryItem)
}

class AddCategoryViewController: UIViewController {
    
    
    @IBOutlet weak var saveCategoryButtonOutlet: UIButton!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    @IBOutlet weak var newCategoryLable: UILabel!
    @IBOutlet weak var enterCategoryLable: UILabel!
    
    var delegate : AddCategoryViewControllerDelegate?
    
    @IBOutlet weak var addCategoryTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        addCategoryTextField.delegate = self as? UITextFieldDelegate
        // Do any additional setup after loading the view.
    }
    // press button ADD
    @IBAction func saveCategoryButtonAction(_ sender: UIButton) {
        print("Press ADD")
        let category = CategoryItem(nameCategory: addCategoryTextField.text ?? "")
        delegate?.addCategoryViewController(self, didAddCategory: category)
        print(category.nameCategory)
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        guard let entity = NSEntityDescription.entity(forEntityName: "Item", in: context) else { return }
//        let itemCategory = NSManagedObject(entity: entity, insertInto: context)
//        itemCategory.setValue(addCategoryTextField.text, forKey: "categoryItem")
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch let error {
//                print("Не удалось сохранить из-за ошибки \(error).")
//            }
//        }
        dismiss(animated: true, completion: nil)
    }
    
    // press button CANCEL
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        print("Press CANCEL.")
        dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
