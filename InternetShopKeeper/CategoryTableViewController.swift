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

class CategoryTableViewController: UITableViewController, AddCategoryViewControllerDelegate {
    
    
    @IBOutlet weak var addCategoryButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var sortButtonOutlet: UIBarButtonItem!
    
    // create array with CategoryStruct for view in tableview
    var categoriesStruct = [CategoryStruct]()
    // cteate dropDown barButtonItem
    let leftBarDropDown = DropDown()
    // create array for coreData
    var categories = [Categories]()
    // create property for search bar and filtered results
    let search = UISearchController(searchResultsController: nil)
    var filteredCategories = [CategoryStruct]()
    var isSearchBarEmpty: Bool {
        return search.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return search.isActive && !isSearchBarEmpty
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // load array from coreData and get to array table view
        fetchCategory()
        getAllCategory()
        // configurate BarButtonItem DropDown
        leftBarDropDown.anchorView = sortButtonOutlet
        leftBarDropDown.dataSource = ["Сортувати А - Я", "Сортувати Я - А"]
        leftBarDropDown.cellConfiguration = { (index, item) in return "\(item)" }
        leftBarDropDown.shadowColor = UIColor.black
        leftBarDropDown.shadowOpacity = 0.8
        leftBarDropDown.setupCornerRadius(10)
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
    // fetch category from coreData
    func fetchCategory(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Categories.fetchRequest() as NSFetchRequest<Categories>
        do {
            self.categories = try context.fetch(fetchRequest)
        } catch let error {
            print("Error: \(error).")
        }
    }
    // add save cayegory to coreData
    func saveCategory(category: CategoryStruct) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newCategory = Categories(context: context)
        newCategory.name = category.name
        newCategory.id = category.id
            do {
                try context.save()
               } catch let error {
                print("Error \(error).")
            }
    }
    // update category in coreDate
    func updateCategory(id: String) {
        //TODO
    }
    // remove category from coreDate
    func removeCategory() {
        //TODO
    }
    // get category from core data to array what will view in tableview
    func getAllCategory() {
        for category in categories {
            var newCategoryStruct = CategoryStruct(name: "", id: "")
            newCategoryStruct.name = category.name ?? ""
            newCategoryStruct.id = category.id ?? ""
            categoriesStruct.append(newCategoryStruct)
        }
    }
    // get category for id from coreData
    func getIdCategory() {
        //TODO
    }
    // func for filter Content For Search Text
    func filterContentForSearchText(_ searchText: String) {
      filteredCategories = categoriesStruct.filter { (category: CategoryStruct) -> Bool in
        return (category.name.lowercased().contains(searchText.lowercased()))
      }
      tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // number of row return from coredata or filtering results
        if isFiltering {
            return filteredCategories.count
        }
        return categoriesStruct.count
    }
    // configurate cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let category: CategoryStruct
        if isFiltering {
            category = filteredCategories[indexPath.row]
        } else {
            category = categoriesStruct[indexPath.row]
        }
        let itemCategory = category.name
        cell.textLabel?.text = itemCategory
        return cell
    }
    // Selected Row for see details
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "AddCategoryViewController") as? AddCategoryViewController else { return }
        _ = vc.view
        vc.isInEdit = true
        vc.addCategoryTextField.text = categoriesStruct[indexPath.row].name
        vc.newCategoryLable.text = "Категорія товару"
        vc.enterCategoryLable.text = "Створена категорія товару"
//        if vc.isEditing {
//            print("Core data update")
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            let context = appDelegate.persistentContainer.viewContext
//            let fetchRequest = Categories.fetchRequest() as NSFetchRequest<Categories>
//            do {
//                categories = try context.fetch(fetchRequest)
//                if categories.count > 0 {
//                    let category =  categories[indexPath.row] as NSManagedObject
//                    category.setValue(vc.addCategoryTextField.text, forKey: "name")
//                    do {
//                        try context.save()
//                    } catch let error {
//                        print("Error \(error).")
//                    }
//                }
//            } catch let error {
//                    print("Error \(error).")
//            }
//        }
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
    // cofigurate sortButtonAction with dropDown view
    @IBAction func sortButtonAction(_ sender: UIBarButtonItem) {
        // filter categories by select item of dropDown
        leftBarDropDown.selectionAction = { (index: Int, item: String) in
            switch index {
            case 0:
                self.categoriesStruct = self.categoriesStruct.sorted {$0.name.lowercased() < $1.name.lowercased()}
                self.tableView.reloadData()
                print(self.categoriesStruct)
            case 1:
                self.categoriesStruct = self.categoriesStruct.sorted {$0.name.lowercased() > $1.name.lowercased()}
                self.tableView.reloadData()
                print(self.categoriesStruct)
            default: break
            }
          print("Selected item: \(item) at index: \(index)") }
        leftBarDropDown.width = 140
        leftBarDropDown.bottomOffset = CGPoint(x: 0, y:(leftBarDropDown.anchorView?.plainView.bounds.height)!)
        leftBarDropDown.show()
        leftBarDropDown.dismissMode = .onTap
    }
    // configure func addCategoryViewController
    func addCategoryViewController(_ addCategoryViewController: AddCategoryViewController, didAddCategory category: CategoryStruct) {
        categoriesStruct.append(category)
        saveCategory(category: category)
        tableView.reloadData()
    }
    // configure segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let desctinationVC = segue.destination as? AddCategoryViewController else { return }
        desctinationVC.delegate = self
    }
}
// add extension UISearchResultsUpdating to CategoryTableViewController
extension CategoryTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = search.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

