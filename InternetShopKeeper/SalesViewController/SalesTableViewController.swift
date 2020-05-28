//
//  SalesTableViewController.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 19.04.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit
import CoreData
import DropDown

class SalesTableViewController: UITableViewController {
    
    
    @IBOutlet weak var sortButtonOutlet: UIBarButtonItem!
    
    // add instance of CRUDModelSales
    let crudModelSales = CRUDModelSales()
    // create array SalesStruct
    var salesStruct = [SalesStruct]()
    // create array Sales
    var sales = [Sales]()
    // create array for sales statistic
    var salesStructStatistic = [SalesStruct]()
    //add instance for color app
    var color = [AppColor]()
    //create instance CRUDModelAppColor for read color from core date
    let crudModelAppColor = CRUDModelAppColor()
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
    // create dropDown barButtonItem
    let leftBarDropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // load array from coreData and get to array table view
        sales = crudModelSales.fetchSale(sales: sales)
        salesStruct = crudModelSales.getAllSale(sales: sales)
        salesStructStatistic = crudModelSales.getAllSale(sales: sales)
        //register nib file
        let nib = UINib(nibName: "SalesTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SalesTableViewCell")
        // get notification center to receive
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: .colorNotificationKey, object: nil)
        // configure navigationItem and navigationBar
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.title = "Мої продажі".localized
        navigationItem.title = "Мої продажі".localized
        // configure search controller
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = true
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Пошук продажі".localized
        definesPresentationContext = true
        // configure BarButtonItem DropDown
        sortButtonOutlet.title = "Сортувати".localized
        leftBarDropDown.anchorView = sortButtonOutlet
        leftBarDropDown.dataSource = ["Сортувати товари по назві А - Я".localized, "Сортувати товари по назві Я - А".localized, "Новіші".localized, "Старіші".localized]
        leftBarDropDown.cellConfiguration = { (index, item) in return "\(item)" }
        leftBarDropDown.shadowOpacity = 0.8
        leftBarDropDown.shadowColor = .black
        leftBarDropDown.cornerRadius = 10
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.tableView.rowHeight = 110.0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.sales = self.crudModelSales.fetchSale(sales: self.sales)
            self.salesStruct = self.crudModelSales.getAllSale(sales: self.sales)
            self.salesStructStatistic = self.crudModelSales.getAllSale(sales: self.sales)
            self.tableView.reloadData()
            print(self.salesStruct.count)
            print(self.sales.count)
        }
        setupColorApp()
    }
    // func for filter Content For Search Text
    func filterContentForSearchText(_ searchText: String) {
        filteredSalesStruct = salesStruct.filter { (sale: SalesStruct) -> Bool in
            return (sale.title.lowercased().contains(searchText.lowercased())) || (sale.category.lowercased().contains(searchText.lowercased()) || sale.date.lowercased().contains(searchText.lowercased()))
        }
        tableView.reloadData()
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //number of row return from array items or filtering results
        if isFiltering {
            return filteredSalesStruct.count
        }
        return salesStruct.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SalesTableViewCell", for: indexPath) as? SalesTableViewCell else { return UITableViewCell() }
        let sale : SalesStruct
        if isFiltering {
            sale = filteredSalesStruct[indexPath.row]
        } else {
            sale = salesStruct[indexPath.row]
        }
        cell.titleSaleItemLable.text = sale.title
        cell.categorySaleItemLable.text = sale.category
        cell.priceSaleItemLable.text = sale.price + "₴"
        cell.amountSaleItemLable.text = sale.amount
        cell.dateSaleItemLable.text = sale.date
        cell.imageSaleItem.image = sale.image
        return cell
    }
    // Trailing swipe configure delete  sale
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Видалити".localized) {[weak self] (_,_,_) in
            // delete sale from array and core data
            self?.salesStruct.remove(at: indexPath.row)
            self?.salesStructStatistic.remove(at: indexPath.row)
            self?.tableView.deleteRows(at: [indexPath], with: .fade)
            self?.tableView.reloadSections([indexPath.section], with: .fade)
            DispatchQueue.main.async {
                self?.crudModelSales.removeSale(sale: self?.sales[indexPath.row])
            }
            print("Delete happens")
        }
        let swipeAction = UISwipeActionsConfiguration(actions: [contextItem])
        swipeAction.performsFirstActionWithFullSwipe = false
        return swipeAction
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
        DispatchQueue.main.async {
            self.salesStruct.append(sale)
            self.salesStructStatistic.append(sale)
            self.sales.append(self.crudModelSales.saveSale(sale: sale))
        }
        print(sale)
        print(salesStruct.count)
        print(sales.count)
    }
    // configure sortButtonAction
    @IBAction func sortButtonAction(_ sender: UIBarButtonItem) {
        // sort sales by select sale of dropDown
        leftBarDropDown.selectionAction = { (index: Int, item: String) in
            switch index {
            case 0:
                self.salesStruct = self.salesStruct.sorted {$0.title.lowercased() < $1.title.lowercased()}
                self.tableView.reloadData()
                print(self.salesStruct)
            case 1:
                self.salesStruct = self.salesStruct.sorted {$0.title.lowercased() > $1.title.lowercased()}
                self.tableView.reloadData()
                print(self.salesStruct)
            case 2:
                self.salesStruct = self.salesStruct.sorted {$0.date.lowercased() > $1.date.lowercased()}
                self.tableView.reloadData()
                print(self.salesStruct)
            case 3:
                self.salesStruct = self.salesStruct.sorted {$0.date.lowercased() < $1.date.lowercased()}
                self.tableView.reloadData()
                print(self.salesStruct)
            default: break
            }
            print("Selected item: \(item) at index: \(index)") }
        leftBarDropDown.width = 250
        leftBarDropDown.bottomOffset = CGPoint(x: 0, y:(leftBarDropDown.anchorView?.plainView.bounds.height)!)
        leftBarDropDown.show()
        leftBarDropDown.dismissMode = .onTap
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

// add extension UISearchResultsUpdating to SalesTableViewController
extension SalesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = search.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

