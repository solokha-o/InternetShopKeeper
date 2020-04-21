//
//  SalesTableViewController.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 19.04.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit
import CoreData

class SalesTableViewController: UITableViewController {
    
    // add instance of CRUDModelSales
    let crudModelSales = CRUDModelSales()
    // create array SalesStruct
    var salesStruct = [SalesStruct]()
    // create array Sales
    var sales = [Sales]()
    //create Bool for state of using coreData
    var isUpdateCoreData = false
    // create property for search bar and filtered results
    let search = UISearchController(searchResultsController: nil)
    var filteredSalesStruct = [SalesStruct]()
    var isSearchBarEmpty: Bool {
        return search.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return search.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // load array from coreData and get to array table view
        sales = crudModelSales.fetchSale(sales: sales)
        salesStruct = crudModelSales.getAllSale(sales: sales)
        //register nib file
        let nib = UINib(nibName: "SalesTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SalesTableViewCell")
        // configure navigationItem and navigationBar
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.title = "Мої продажі".localized
        navigationItem.title = "Мої продажі".localized
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.tableView.rowHeight = 110.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadTable()
    }
    // reload tableWiev
    func reloadTable() {
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // number of row return from array items or filtering results
//        if isFiltering {
//            return filteredSalesStruct.count
//        }
        return salesStruct.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SalesTableViewCell", for: indexPath) as? SalesTableViewCell else { return UITableViewCell() }
        let sale : SalesStruct
//        if isFiltering {
//            sale = filteredSalesStruct[indexPath.row]
//        } else {
            sale = salesStruct[indexPath.row]
//        }
        cell.titleSaleItemLable.text = sale.title
        cell.categorySaleItemLable.text = sale.category
        cell.priceSaleItemLable.text = sale.price
        cell.amountSaleItemLable.text = sale.amount
        cell.imageSaleItem.image = sale.image
        return cell
    }
    
//    func addItemSaleViewController(_ addItemSaleViewController: AddItemViewController, didAddItemSale sale: SalesStruct) {
//        // if state edit coreData we find category for id and update in coreData and  tableview
//        print(sale.id)
//        if isUpdateCoreData{
//            for i in salesStruct.indices {
//                if salesStruct[i].id == sale.id {
//                    salesStruct[i].title = sale.title
//                    salesStruct[i].category = sale.category
//                    salesStruct[i].price = sale.price
//                    salesStruct[i].amount = sale.amount
//                    salesStruct[i].image = sale.image
//                    salesStruct[i].date = sale.date
//                    crudModelSales.updateSale(sales: sales, id: sale.id, sale: sale)
//                    salesStruct[i] = sale
//                    print("update sale" + sale.id)
//                }
//            }
//            isUpdateCoreData = false
//        } else {
//            // else save to coreData and and view in tableview
//            salesStruct.append(sale)
//            sales.append(crudModelSales.saveSale(sale: sale))
//            print("Save sale" + sale.id)
//        }
//        tableView.reloadData()
//    }
//    // configure segue
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: sender)
//        guard let desctinationVC = segue.destination as? AddItemViewController else { return }
//        desctinationVC.delegateSale = self
//        isUpdateCoreData = false
//    }
    // append sale to array
    func appendSale(sale: SalesStruct) {
        salesStruct.append(sale)
        sales.append(crudModelSales.saveSale(sale: sale))
        print(sale)
        print(salesStruct)
    }
}
