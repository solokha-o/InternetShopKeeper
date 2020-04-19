//
//  ItemTableViewController.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 28.02.20.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit
import CoreData
import DropDown


class ItemTableViewController: UITableViewController, AddItemViewControllerDelegate {
   
    @IBOutlet weak var sortButtonOutlet: UIBarButtonItem!
    
    //add instance of CRUDModelItem
    let crudModelItem = CRUDModelItem()
    // create array with ItemStruct for view in tableview
    var itemsStruct = [ItemStruct]()
    // cteate dropDown barButtonItem
    let leftBarDropDown = DropDown()
    // add array of items
    var items = [Item]()
    // create property for search bar and filtered results
    let search = UISearchController(searchResultsController: nil)
    var filteredItemsStruct = [ItemStruct]()
    var isSearchBarEmpty: Bool {
        return search.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return search.isActive && !isSearchBarEmpty
    }
    //create Bool for state of using coreData
    var isUpdateCoreData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // load array from coreData and get to array table view
        items = crudModelItem.fetchItem(items: items)
        itemsStruct = crudModelItem.getAllItem(items: items)
        // configurate BarButtonItem DropDown
        sortButtonOutlet.title = "Сортувати".localized
        leftBarDropDown.anchorView = sortButtonOutlet
        leftBarDropDown.dataSource = ["Сортувати товари по назві А - Я".localized, "Сортувати товари по назві Я - А".localized]
        leftBarDropDown.cellConfiguration = { (index, item) in return "\(item)" }
        leftBarDropDown.cornerRadius = 10
        leftBarDropDown.shadowColor = UIColor.black
        leftBarDropDown.shadowOpacity = 0.8
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.title = "Мій товар".localized
        navigationItem.title = "Мій товар".localized
        //add searchController to navigationItem
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = true
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Пошук товару".localized
        definesPresentationContext = true
        let nib = UINib(nibName: "ItemTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ItemTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.tableView.rowHeight = 130.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

    // func for filter Content For Search Text
    func filterContentForSearchText(_ searchText: String) {
      filteredItemsStruct = itemsStruct.filter { (item: ItemStruct) -> Bool in
        return (item.title.lowercased().contains(searchText.lowercased()) || item.category.lowercased().contains(searchText.lowercased()))
      }
      tableView.reloadData()
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // number of row return from array items or filtering results
        if isFiltering {
            return filteredItemsStruct.count
        }
        return itemsStruct.count    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath) as? ItemTableViewCell else { return UITableViewCell() }
        let item : ItemStruct
        if isFiltering {
            item = filteredItemsStruct[indexPath.row]
        } else {
            item = itemsStruct[indexPath.row]
        }
        cell.titleItemLable.text = item.title
        cell.categoryItemLable.text = item.category
        cell.priceItemLable.text = item.price
        cell.amountItemLable.text = item.amount
        cell.detailsItemLable.text = item.details
        cell.imageItemView.image = item.image
        return cell
    }
    // Selected Row you see details
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "AddItemViewController") as? AddItemViewController else { return }
        _ = vc.view
        isUpdateCoreData = true
        // configure AddItemViewController for state isInEdit
        vc.isInEdit = true
        vc.item.id = itemsStruct[indexPath.row].id
        vc.titleItemTextField.text = itemsStruct[indexPath.row].title
        vc.categoryItemTextField.text = itemsStruct[indexPath.row].category
        vc.priceItemTextField.text = itemsStruct[indexPath.row].price
        vc.amountItemTextField.text = itemsStruct[indexPath.row].amount
        vc.detailsItemTextView.text = itemsStruct[indexPath.row].details
        vc.addImage.image = itemsStruct[indexPath.row].image
        vc.addImage.isHighlighted = false
        vc.newItemLabel.text = "Твій товар".localized
        vc.enterImageItemLable.text = "Фото товару".localized
        vc.delegate = self
        present(vc, animated: true, completion: nil)
        }
    // Trailing swipe configutate delete  item
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Видалити".localized) {  [weak self] (_, _, _) in
            // delete category from CoreData
            self?.itemsStruct.remove(at: indexPath.row)
            self?.tableView.deleteRows(at:[indexPath],with: .fade)
            self?.tableView.reloadSections([indexPath.section], with: .automatic)
            self?.crudModelItem.removeItem(item: self?.items[indexPath.row])
            print("DELETE HAPPENS")
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        swipeActions.performsFirstActionWithFullSwipe = false
        return swipeActions
    }
    @IBAction func sortButtonAction(_ sender: UIBarButtonItem) {
        // filter items by select item of dropDown
        leftBarDropDown.selectionAction = { (index: Int, item: String) in
            switch index {
            case 0:
                self.itemsStruct = self.itemsStruct.sorted {$0.title.lowercased() < $1.title.lowercased()}
                self.tableView.reloadData()
                print(self.itemsStruct)
            case 1:
                self.itemsStruct = self.itemsStruct.sorted {$0.title.lowercased() > $1.title.lowercased()}
                self.tableView.reloadData()
                print(self.itemsStruct)
            default: break
            }
          print("Selected item: \(item) at index: \(index)") }
        leftBarDropDown.width = 250
        leftBarDropDown.bottomOffset = CGPoint(x: 0, y:(leftBarDropDown.anchorView?.plainView.bounds.height)!)
        leftBarDropDown.show()
        leftBarDropDown.dismissMode = .onTap
    }
    // delegate function of AddItemViewController
    func addItemViewController(_ addItemViewController: AddItemViewController, didAddItem item: ItemStruct) {
        // if state edit coreData we find category for id and update in coreData and  tableview
        print(item.id)
        if isUpdateCoreData{
            for i in 0..<itemsStruct.count {
                if itemsStruct[i].id == item.id {
                    itemsStruct[i].title = item.title
                    itemsStruct[i].category = item.category
                    itemsStruct[i].price = item.price
                    itemsStruct[i].amount = item.amount
                    itemsStruct[i].details = item.details
                    itemsStruct[i].incomePrice = item.incomePrice
                    itemsStruct[i].image = item.image
                    itemsStruct[i].date = item.date
                    crudModelItem.updateItem(items: items, id: item.id, item: item)
                    itemsStruct[i] = item
                    print("update " + item.id)
                }
            }
            isUpdateCoreData = false
        } else {
            // else save to coreData and and view in tableview
            itemsStruct.append(item)
            items.append(crudModelItem.saveItem(item: item))
            print("Save " + item.id)
        }
        tableView.reloadData()
    }
    // configure segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let desctinationVC = segue.destination as? AddItemViewController else { return }
        desctinationVC.delegate = self
        isUpdateCoreData = false
    }
    
}

// add extension UISearchResultsUpdating to CategoryTableViewController
extension ItemTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = search.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
