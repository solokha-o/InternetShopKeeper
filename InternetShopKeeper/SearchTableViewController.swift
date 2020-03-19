//
//  SearchTableViewController.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 16.03.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit
import CoreData

class SearchTableViewController: UITableViewController {

    // array of item from core data
    var items = [Item]()
    // create property for search bar and filtered results
    let search = UISearchController(searchResultsController: nil)
    var filteredItem = [Item]()
    var isSearchBarEmpty: Bool {
        return search.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return search.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
        let nib = UINib(nibName: "ItemTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ItemTableViewCell")
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Введи назву товару"
        definesPresentationContext = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.reloadData()
        self.tableView.rowHeight = 130.0
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    // Load data from coredata to table view
    func loadData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Item.fetchRequest() as NSFetchRequest<Item>
        do {
            items = try context.fetch(fetchRequest)

        } catch let error {
            print("Error: \(error).")
        }
    }
    // func for filter Content For Search Text
    func filterContentForSearchText(_ searchText: String) {
      filteredItem = items.filter { (category: Item) -> Bool in
        return (category.titleItem?.lowercased().contains(searchText.lowercased()) ?? false)
      }
      tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredItem.count
        }
        return filteredItem.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath) as? ItemTableViewCell else {return UITableViewCell()}
        let item: Item
        if isFiltering {
            item = filteredItem[indexPath.row]
            let imageLoad = UIImage(data: item.imageItem!)
            cell.imageItemView.image = imageLoad
            cell.titleItemLable.text = item.titleItem
            cell.categoryItemLable.text = item.categoryItem
            cell.priceItemLable.text = item.priceItem
            cell.amountItemLable.text = item.amountItem
            cell.detailsItemLable.text = item.detailsItem
        }
        return cell
    }
    // Selected Row you see details
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "AddItemViewController") as? AddItemViewController else { return }
        _ = vc.view
        vc.isInEdit = true
        vc.titleItemTextField.text = filteredItem[indexPath.row].titleItem
        vc.categoryItemTextField.text = filteredItem[indexPath.row].categoryItem
        vc.priceItemTextField.text = filteredItem[indexPath.row].priceItem
        vc.amountItemTextField.text = filteredItem[indexPath.row].amountItem
        vc.detailsItemTextfield.text = filteredItem[indexPath.row].detailsItem
        vc.newItemLabel.text = "Твій товар"
        vc.enterImageItemLable.text = "Фото товару"
        present(vc, animated: true, completion: nil)
        }
}
// add extension UISearchResultsUpdating to SearchTableViewController
extension SearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = search.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
