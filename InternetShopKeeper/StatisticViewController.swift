//
//  StatisticViewController.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 24.03.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit
import CoreData

class StatisticViewController: UIViewController {

    @IBOutlet weak var costsLabel: UILabel!
    @IBOutlet weak var profitLable: UILabel!
    @IBOutlet weak var netProfitLable: UILabel!
    @IBOutlet weak var costsTitleLable: UILabel!
    @IBOutlet weak var profitTitleLable: UILabel!
    @IBOutlet weak var netProfitTitleLable: UILabel!
    
    // create array Item
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRequest()
        costsTitleLable.text = "Витрачено на товар".localized
        profitTitleLable.text = "Отримано від продажу".localized
        netProfitTitleLable.text = "Чистий дохід".localized
        navigationController?.title = "Статистика".localized
        navigationItem.title = "Статистика".localized
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        setupCostsLabel()
        setupProfitLable()
        setupNetProfitLable()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRequest()
    }
    //     fetch request from coreData and get to array items
    func fetchRequest() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Item.fetchRequest() as NSFetchRequest<Item>
                do {
            items = try context.fetch(fetchRequest)

        } catch let error {
            print("Eror: \(error).")
        }
    }
    // calculation costs bought item
    func costCalculation(items: [Item]) -> String {
        var costs = 0
        for item in items {
            costs += ((Int(item.priceItem ?? "0") ?? 0) * (Int(item.amountItem ?? "0") ?? 0))
            print(costs)
        }
        print(costs)
        return String(costs)
    }
    // view costs in costsLabel
    func setupCostsLabel() {
        let costs = costCalculation(items: items)
        costsLabel.text = costs
    }
    // calculation costs sold item
    func profitCalculation(items: [Item]) -> String {
        var profit = 0
        for item in items {
            profit += (Int(item.incomePriceItem ?? "0") ?? 0)
        }
        print(profit)
        return String(profit)
    }
    // view profit in profitLable
    func setupProfitLable() {
        let profit = profitCalculation(items: items)
        profitLable.text = profit
    }
    // calculation net profit item
    func netProfitCalculation() -> String {
        let costs = costCalculation(items: items)
        let profit = profitCalculation(items: items)
        let netProfit = (Int(profit) ?? 0) - (Int(costs) ?? 0)
        print(netProfit)
        return String(netProfit)
    }
    // view net profit in netProfitLable
    func setupNetProfitLable() {
        let netProfit = netProfitCalculation()
        netProfitLable.text = netProfit
    }
}
