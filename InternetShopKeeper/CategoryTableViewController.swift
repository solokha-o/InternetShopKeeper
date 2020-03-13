//
//  CategoryTableViewController.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 09.03.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categories = [Categories]()
    
//    var categories = [CategoryItem]()

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }

    func reload() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Categories.fetchRequest() as NSFetchRequest<Categories>
        do {
            categories = try context.fetch(fetchRequest)

        } catch let error {
            print("Error: \(error).")
        }
        self.tableView.reloadData()
    }

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
        let itemCategory = category.name ?? ""
        cell.textLabel?.text = itemCategory
        

        
    //    cell.textLabel?.text = category.categoryItem
   //     cell.detailTextLabel?.text = "Категорія товару"
        return cell
    }
    // Selected Row you see details
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  let category = categoryVC.categoryArray[indexPath.row]
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "AddCategoryViewController") as? AddCategoryViewController else { return }
        _ = vc.view
        vc.isEditing = true
        vc.addCategoryTextField.text = categories[indexPath.row].name
        vc.newCategoryLable.text = "Категорія товару"
        vc.enterCategoryLable.text = "Створена категорія товару"
        present(vc, animated: true, completion: nil)
        }
    // Trailing swipe configutate delete category item
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Видалити") {  [weak self] (_, _, _) in
            // delete category from CoreData
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete((self?.categories[indexPath.row])!)
            self?.categories.remove(at: indexPath.row)
            self?.tableView.deleteRows(at:[indexPath],with: .fade)
            do{
                try context.save()
            } catch let error {
                print("Error \(error).")
            }
            self?.tableView.reloadSections([indexPath.section], with: .automatic)
            print("DELETE HAPPENS")
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        swipeActions.performsFirstActionWithFullSwipe = false
        return swipeActions
    }
}

