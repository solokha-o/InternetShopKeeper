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
    
    @IBOutlet weak var addCategoryButtonOutlet: UIBarButtonItem!
    var categories = [Categories]()
    // create property for search bar and filtered results
    let search = UISearchController(searchResultsController: nil)
    var filteredCategories = [Categories]()
    var isSearchBarEmpty: Bool {
        return search.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return search.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem?.titlePositionAdjustment(for: .compactPrompt)
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        let fetchRequest = Item.fetchRequest() as NSFetchRequest<Item>
//                do {
//            categories = try context.fetch(fetchRequest)
//
//        } catch let error {
//            print("Не удалось загрузить данные из-за ошибки: \(error).")
//        }
        // Navigation bar have large title and search controller
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Пошук категорії"
        definesPresentationContext = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.prefersLargeTitles = true
        reloadCategoryTableViewController()
    }
// func for reloat tableview
    func reloadCategoryTableViewController() {
        tableView.reloadData()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Categories.fetchRequest() as NSFetchRequest<Categories>
        do {
            categories = try context.fetch(fetchRequest)

        } catch let error {
            print("Error: \(error).")
        }
        tableView.reloadData()
    }
    // func for filter Content For Search Text
    func filterContentForSearchText(_ searchText: String,
                                    category: Categories? = nil) {
      filteredCategories = categories.filter { (category: Categories) -> Bool in
        return (category.name?.lowercased().contains(searchText.lowercased()) ?? false)
      }
      tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // number of row return from coredata or filtering results
        if isFiltering {
            return filteredCategories.count
        }
        return categories.count
    }

    // configurate cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let category: Categories
        if isFiltering {
            category = filteredCategories[indexPath.row]
        } else {
            category = categories[indexPath.row]
        }
        let itemCategory = category.name ?? ""
        cell.textLabel?.text = itemCategory
        

        
    //    cell.textLabel?.text = category.categoryItem
   //     cell.detailTextLabel?.text = "Категорія товару"
        return cell
    }
    // Selected Row you see details
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "AddCategoryViewController") as? AddCategoryViewController else { return }
        _ = vc.view
        vc.isInEdit = true
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
// add extension UISearchResultsUpdating to CategoryTableViewController
extension CategoryTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = search.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    
}

