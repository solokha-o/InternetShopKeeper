//
//  CategoryTableViewController.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 09.03.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//
import UIKit
import CoreData
import DropDown

class CategoryTableViewController: UITableViewController {
    
    @IBOutlet weak var addCategoryButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var sortButtonOutlet: UIBarButtonItem!
    
    // cteate dropDown barButtonItem
    let leftBarDropDown = DropDown()
    // create array for coreData
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadCategoryTableViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadCategoryTableViewController()
        // configurate BarButtonItem DropDown
        leftBarDropDown.anchorView = sortButtonOutlet
        leftBarDropDown.dataSource = ["Сортувати А - Я", "Сортувати Я - А"]
        leftBarDropDown.cellConfiguration = { (index, item) in return "\(item)" }
        leftBarDropDown.shadowColor = UIColor.black
        leftBarDropDown.shadowOpacity = 0.8
        leftBarDropDown.setupCornerRadius(10)
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
        navigationItem.hidesSearchBarWhenScrolling = true
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Пошук категорії"
        definesPresentationContext = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
    }
    // func for reloat tableview
    func reloadCategoryTableViewController() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Categories.fetchRequest() as NSFetchRequest<Categories>
        do {
            self.categories = try context.fetch(fetchRequest)

        } catch let error {
            print("Error: \(error).")
        }
        self.tableView.reloadData()
    }
    // func for filter Content For Search Text
    func filterContentForSearchText(_ searchText: String) {
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
        return cell
    }
    // Selected Row for see details
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "AddCategoryViewController") as? AddCategoryViewController else { return }
        _ = vc.view
        vc.isInEdit = true
        vc.addCategoryTextField.text = categories[indexPath.row].name
        vc.newCategoryLable.text = "Категорія товару"
        vc.enterCategoryLable.text = "Створена категорія товару"
        present(vc, animated: true, completion: nil)
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        let fetchRequest = Categories.fetchRequest() as NSFetchRequest<Categories>
//        do {
//            categories = try context.fetch(fetchRequest)
//            if categories.count > 0 {
//                let category =  categories[indexPath.row] as NSManagedObject
//                category.setValue(vc.addCategoryTextField.text, forKey: "name")
//                do {
//                    try context.save()
//                } catch let error {
//                    print("Error \(error).")
//                }
//            }
//        } catch let error {
//                print("Error \(error).")
//        }
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
    // cofigurate sortButtonAction with dropDown view
    @IBAction func sortButtonAction(_ sender: UIBarButtonItem) {
        // filter categories by select item of dropDown
        leftBarDropDown.selectionAction = { (index: Int, item: String) in
            switch index {
            case 0:
                self.categories = self.categories.sorted {$0.name! < $1.name!}
                self.tableView.reloadData()
                print(self.categories)
            case 1:
                self.categories = self.categories.sorted {$0.name! > $1.name!}
                self.tableView.reloadData()
                print(self.categories)
            default: break
            }
          print("Selected item: \(item) at index: \(index)") }
        leftBarDropDown.width = 140
        leftBarDropDown.bottomOffset = CGPoint(x: 0, y:(leftBarDropDown.anchorView?.plainView.bounds.height)!)
        leftBarDropDown.show()
        leftBarDropDown.dismissMode = .onTap
    }
}
// add extension UISearchResultsUpdating to CategoryTableViewController
extension CategoryTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = search.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

