//
//  StatisticViewController.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 24.03.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit
import CoreData

class StatisticViewController: UIViewController, ItemTableViewControllerDelegate {

    @IBOutlet weak var costsLabel: UILabel!
    @IBOutlet weak var profitLable: UILabel!
    @IBOutlet weak var netProfitLable: UILabel!
    @IBOutlet weak var costsTitleLable: UILabel!
    @IBOutlet weak var profitTitleLable: UILabel!
    @IBOutlet weak var netProfitTitleLable: UILabel!
    
    // create array ItemStruct
    var itemsStruct = [ItemStruct]()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        costsTitleLable.text = "Витрачено на товар".localized
        profitTitleLable.text = "Отримано від продажу".localized
        netProfitTitleLable.text = "Чистий дохід".localized
        navigationController?.title = "Статистика".localized
        navigationItem.title = "Статистика".localized
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        let itemTVC = ItemTableViewController()
        itemTVC.delegateItemStruct()
        setupCostsLabel()
        setupProfitLable()
        setupNetProfitLable()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
//    //     fetch request from coreData and get to array items
//    func fetchRequest() {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        let fetchRequest = Item.fetchRequest() as NSFetchRequest<Item>
//                do {
//            items = try context.fetch(fetchRequest)
//
//        } catch let error {
//            print("Eror: \(error).")
//        }
//    }
    
    
    // calculation costs bought item
    func costCalculation(items: [ItemStruct]) -> String {
        var costs = 0
        for item in items {
            costs += ((Int(item.price) ?? 0) * (Int(item.amount) ?? 0))
            print(costs)
        }
        print(costs)
        return String(costs)
    }
    // view costs in costsLabel
    func setupCostsLabel() {
        let costs = costCalculation(items: itemsStruct)
        costsLabel.text = costs
    }
    // calculation costs sold item
    func profitCalculation(items: [ItemStruct]) -> String {
        var profit = 0
        for item in items {
            profit += (Int(item.incomePrice) ?? 0)
        }
        print(profit)
        return String(profit)
    }
    // view profit in profitLable
    func setupProfitLable() {
        let profit = profitCalculation(items: itemsStruct)
        profitLable.text = profit
    }
    // calculation net profit item
    func netProfitCalculation() -> String {
        let costs = costCalculation(items: itemsStruct)
        let profit = profitCalculation(items: itemsStruct)
        let netProfit = (Int(profit) ?? 0) - (Int(costs) ?? 0)
        print(netProfit)
        return String(netProfit)
    }
    // view net profit in netProfitLable
    func setupNetProfitLable() {
        let netProfit = netProfitCalculation()
        netProfitLable.text = netProfit
    }
    // delegating itemsStruct array
    func itemTableViewController(_ itemTableViewController: ItemTableViewController, didAddItems items: [ItemStruct]) {
        itemsStruct = items
        print(items)
    }
    
    
    // configure prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let desctinationVC = segue.destination as? ItemTableViewController else { return }
        if self.isViewLoaded {
            desctinationVC.delegate = self
        }
    }
}
