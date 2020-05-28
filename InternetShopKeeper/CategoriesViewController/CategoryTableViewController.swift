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
    
    //create instance of CRUDModelCategory
    let crudModelCategory = CRUDModelCategory()
    // create array with CategoryStruct for view in tableview
    var categoriesStruct = [CategoryStruct]()
    // cteate dropDown barButtonItem
    let leftBarDropDown = DropDown()
    // create array for coreData
    var categories = [Categories]()
    //add instance for color app
    var color = [AppColor]()
    //create instance CRUDModelAppColor for read color from core date
    let crudModelAppColor = CRUDModelAppColor()
    // create property for search bar and filtered results
    let search = UISearchController(searchResultsController: nil)
    var filteredCategories = [CategoryStruct]()
    var isSearchBarEmpty: Bool {
        return search.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return search.isActive && !isSearchBarEmpty
    }
    //create Bool for state of using coreData
    var isUpdateCoreData = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupColorApp()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // load array from coreData and get to array table view
        categories = crudModelCategory.fetchCategory(categories: categories)
        categoriesStruct = crudModelCategory.getAllCategory(categories: categories)
        // get notification center to receive
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: .colorNotificationKey, object: nil)
        // configure BarButtonItem DropDown
        sortButtonOutlet.title = "Сортувати".localized
        leftBarDropDown.anchorView = sortButtonOutlet
        leftBarDropDown.dataSource = ["Сортувати А - Я".localized, "Сортувати Я - А".localized]
        leftBarDropDown.cellConfiguration = { (index, item) in return "\(item)" }
        leftBarDropDown.shadowColor = UIColor.black
        leftBarDropDown.shadowOpacity = 0.8
        leftBarDropDown.setupCornerRadius(10)
        // Navigation bar have large title and search controller
        navigationController?.title = "Категорії".localized
        navigationItem.title = "Категорії товару".localized
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = true
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Пошук категорії".localized
        definesPresentationContext = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
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
        // number of row return from array categories or filtering results
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
        isUpdateCoreData = true
        // configure AddCategoryViewController for state isInEdit
        vc.category.id = categoriesStruct[indexPath.row].id
        print("ID" + categoriesStruct[indexPath.row].id)
        vc.isInEdit = true
        vc.addCategoryTextField.text = categoriesStruct[indexPath.row].name
        vc.newCategoryLable.text = "Категорія товару".localized
        vc.enterCategoryLable.text = "Створена категорія товару".localized
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    // Trailing swipe configutate delete category item
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Видалити".localized) {  [weak self] (_, _, _) in
            // delete category from CoreData
            self?.categoriesStruct.remove(at: indexPath.row)
            self?.tableView.deleteRows(at:[indexPath],with: .fade)
            self?.tableView.reloadSections([indexPath.section], with: .fade)
            self?.crudModelCategory.removeCategory(category: self?.categories[indexPath.row])
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
    // configure func addCategoryViewController for delegate
    func addCategoryViewController(_ addCategoryViewController: AddCategoryViewController, didAddCategory category: CategoryStruct) {
        // if state edit coreData we find category for id and update in coreData and  tableview
        if isUpdateCoreData{
            for i in 0..<categoriesStruct.count {
                if categoriesStruct[i].id == category.id {
                    categoriesStruct[i].name = category.name
                    crudModelCategory.updateCategory(categories: categories, id: category.id, category: category)
                    print("update " + category.id)
                }
            }
            isUpdateCoreData = false
        } else {
            // else save to coreData and and view in tableview
            categoriesStruct.append(category)
            categories.append(crudModelCategory.saveCategory(category: category))
            print("Save " + category.id)
        }
        tableView.reloadData()
    }
    
    // configure segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let desctinationVC = segue.destination as? AddCategoryViewController else { return }
        desctinationVC.delegate = self
        isUpdateCoreData = false
    }
    // function call to change color view
    @objc func notificationReceived(_ notification: Notification) {
        guard let color = notification.userInfo?["color"] as? UIColor else { return }
        navigationController?.navigationBar.barTintColor = color
        navigationController?.navigationBar.backgroundColor = color
    }
    // setup color app from core data
    func setupColorApp() {
        color = crudModelAppColor.fetchColor(color: color)
        let uiColor = UIColor.uiColorFromString(string: color[0].color ?? ".systemOrange")
        navigationController?.navigationBar.barTintColor = uiColor
        navigationController?.navigationBar.backgroundColor = uiColor
    }
}
// add extension UISearchResultsUpdating to CategoryTableViewController
extension CategoryTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = search.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

