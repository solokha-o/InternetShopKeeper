//
//  CategoryTableViewController.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 09.03.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController, AddCategoryViewControllerDelegate {
    
    
    
    var categories = [CategoryItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        let fetchRequest = Item.fetchRequest() as NSFetchRequest<Item>
//                do {
//            categories = try context.fetch(fetchRequest)
//
//        } catch let error {
//            print("Не удалось загрузить данные из-за ошибки: \(error).")
//        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }
//
//    func reload() {
////        let appDelegate = UIApplication.shared.delegate as! AppDelegate
////        let context = appDelegate.persistentContainer.viewContext
////        let fetchRequest = Item.fetchRequest() as NSFetchRequest<Item>
////        do {
////            items = try context.fetch(fetchRequest)
////
////        } catch let error {
////            print("Не удалось загрузить данные из-за ошибки: \(error).")
////        }
//        tableView.reloadData()
//    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    // configurate cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.nameCategory
        

        
    //    cell.textLabel?.text = category.categoryItem
   //     cell.detailTextLabel?.text = "Категорія товару"
        return cell
    }
    // Selected Row you see details
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  let category = categoryVC.categoryArray[indexPath.row]
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "AddCategoryViewController") as? AddCategoryViewController else { return }
        _ = vc.view
        vc.addCategoryTextField.text = categories[indexPath.row].nameCategory
        vc.saveCategoryButtonOutlet.isHidden = true
        vc.cancelButtonOutlet.setTitle("Назад", for: .normal)
        vc.newCategoryLable.text = "Категорія товару"
        vc.enterCategoryLable.text = "Створена категорія товару"
        vc.addCategoryTextField.isUserInteractionEnabled = false
        present(vc, animated: true, completion: nil)
        }
    // Trailing swipe configutate
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Видалити") {  [weak self] (_, _, _) in
            
            
            self?.categories.remove(at: indexPath.row)
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            let context = appDelegate.persistentContainer.viewContext
//            context.delete((self?.items[indexPath.row])!)
//            self?.items.remove(at: indexPath.row)
//            print("Remove item \(String(describing: self?.items[indexPath.row]))")
            self?.tableView.deleteRows(at:[indexPath],with: .fade)
//            do{
//                try context.save()
//            } catch let error {
//                print("Не удалось сохранить из-за ошибки \(error).")
//            }
            self?.tableView.reloadSections([indexPath.section], with: .automatic)
            print("DELETE HAPPENS")
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        swipeActions.performsFirstActionWithFullSwipe = false
        
        return swipeActions

    }
    func addCategoryViewController(_ addCategoryViewController: AddCategoryViewController, didAddCategory category: CategoryItem) {
        categories.append(category)
        tableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let desctinationVC = segue.destination as? AddCategoryViewController else { return }
        desctinationVC.delegate = self
    }

}
