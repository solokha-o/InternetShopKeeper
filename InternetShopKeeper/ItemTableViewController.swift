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
        fetchItem()
        getAllItem()
        // configurate BarButtonItem DropDown
        leftBarDropDown.anchorView = sortButtonOutlet
        leftBarDropDown.dataSource = ["Сортувати товари по назві А - Я", "Сортувати товари по назві Я - А"]
        leftBarDropDown.cellConfiguration = { (index, item) in return "\(item)" }
        leftBarDropDown.cornerRadius = 10
        leftBarDropDown.shadowColor = UIColor.black
        leftBarDropDown.shadowOpacity = 0.8
        navigationController?.navigationBar.prefersLargeTitles = true
        //add searchController to navigationItem
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = true
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Пошук товару"
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
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    // fetch item from coreData
    func fetchItem(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Item.fetchRequest() as NSFetchRequest<Item>
        do {
            self.items = try context.fetch(fetchRequest)
        } catch let error {
            print("Error: \(error).")
        }
    }
    // add save Item to coreData
    func saveItem(item: ItemStruct) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newItem = Item(context: context)
        newItem.titleItem = item.title
        newItem.categoryItem = item.category
        newItem.priceItem = item.price
        newItem.amountItem = item.amount
        newItem.detailsItem = item.details
        newItem.salePriceItem = item.salePrice
        newItem.imageItem = item.image.pngData()
        newItem.id = item.id
            do {
                try context.save()
               } catch let error {
                print("Error \(error).")
            }
        // add new element to corData array
        items.append(newItem)
    }
    // update item in coreDate
    func updateItem(id: String, item: ItemStruct) {
        for i in 0..<items.count {
            if items[i].id == id {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let fetchRequest = Item.fetchRequest() as NSFetchRequest<Item>
                do {
                    let updateContext = try context.fetch(fetchRequest)
                    if updateContext.count > 0 {
                        let objUpdate =  updateContext[i] as NSManagedObject
                        objUpdate.setValue(item.title, forKey: "titleItem")
                        objUpdate.setValue(item.category, forKey: "categoryItem")
                        objUpdate.setValue(item.price, forKey: "priceItem")
                        objUpdate.setValue(item.amount, forKey: "amountItem")
                        objUpdate.setValue(item.details, forKey: "detailsItem")
                        objUpdate.setValue(item.salePrice, forKey: "salePriceItem")
                        objUpdate.setValue(item.image.pngData(), forKey: "imageItem")
                        do {
                            try context.save()
                        } catch let error {
                            print("Error \(error).")
                        }
                    }
                } catch let error {
                        print("Error \(error).")
                }
            }
        }
    }
    // remove item from coreDate
    func removeItem(item: Item?) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        if let item = item {
            context.delete(item)
        }
        do{
            try context.save()
        } catch let error {
            print("Error \(error).")
        }
    }
    // get item from core data to array what will view in tableview
    func getAllItem() {
        for item in items {
            var newItemStruct = ItemStruct(title: "", category: "", price: "", amount: "", details: "", image: UIImage(imageLiteralResourceName: "AddImage"), id: "", salePrice: "")
            newItemStruct.title = item.titleItem ?? ""
            newItemStruct.category = item.categoryItem ?? ""
            newItemStruct.price = item.priceItem ?? ""
            newItemStruct.amount = item.amountItem ?? ""
            newItemStruct.details = item.detailsItem ?? ""
            newItemStruct.salePrice = item.salePriceItem ?? ""
            newItemStruct.id = item.id ?? ""
            newItemStruct.image = UIImage(data: item.imageItem!)!
            itemsStruct.append(newItemStruct)
        }
    }
    // func for filter Content For Search Text
    func filterContentForSearchText(_ searchText: String) {
      filteredItemsStruct = itemsStruct.filter { (item: ItemStruct) -> Bool in
        return (item.title.lowercased().contains(searchText.lowercased()) || item.category.lowercased().contains(searchText.lowercased()))
      }
      tableView.reloadData()
    }
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
        vc.newItemLabel.text = "Твій товар"
        vc.enterImageItemLable.text = "Фото товару"
        vc.delegate = self
        present(vc, animated: true, completion: nil)
        }
    // Trailing swipe configutate delete  item
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Видалити") {  [weak self] (_, _, _) in
            // delete category from CoreData
            self?.itemsStruct.remove(at: indexPath.row)
            self?.tableView.deleteRows(at:[indexPath],with: .fade)
            self?.tableView.reloadSections([indexPath.section], with: .automatic)
            self?.removeItem(item: self?.items[indexPath.row])
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
                    itemsStruct[i].salePrice = item.salePrice
                    itemsStruct[i].image = item.image
                    updateItem(id: item.id, item: item)
                    print("update " + item.id)
                }
            }
            isUpdateCoreData = false
        } else {
            // else save to coreData and and view in tableview
            itemsStruct.append(item)
            saveItem(item: item)
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
