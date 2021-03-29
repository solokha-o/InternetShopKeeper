//
//  StatisticTableViewController.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 27.04.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit

class StatisticTableViewController: UITableViewController {
    
    
    // create array ItemStruct
    var itemsStruct = [ItemStruct]()
    // create array SaleStruct
    var salesStruct = [SalesStruct]()
    //add instance for color app
    var color = [AppColor]()
    //create instance CRUDModelAppColor for read color from core date
    let crudModelAppColor = CRUDModelAppColor()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupColorApp()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.title = "Статистика".localized
        navigationItem.title = "Статистика".localized
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        // get notification Center to receive
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: .colorNotificationKey, object: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    // configure cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticCell", for: indexPath)
        switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Твої витрати".localized
                cell.detailTextLabel?.text = "Витрати, що зроблені на закупівлю товару".localized
            case 1:
                cell.textLabel?.text = "Твій прибуток".localized
                cell.detailTextLabel?.text = "Інформація щодо прибутку від продажу товару".localized
            case 2:
                cell.textLabel?.text = "Чистий дохід".localized
                cell.detailTextLabel?.text = "Вирахування чистого доходу від продажу товару".localized
            default:
                break
        }
        return cell
    }
    // configure didSelectRowAt
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let costsVC = storyboard?.instantiateViewController(identifier: "CostsViewController") as? CostsViewController, let salesVC  = storyboard?.instantiateViewController(identifier: "SalesViewController") as? SalesViewController, let profitVC = storyboard?.instantiateViewController(identifier: "ProfitViewController") as? ProfitViewController else { return }
        switch indexPath.row {
            case 0:
                costsVC.itemsStruct = itemsStruct
                showDetailViewController(costsVC, sender: nil)
            case 1:
                salesVC.salesStruct = salesStruct
                showDetailViewController(salesVC, sender: nil)
            case 2:
                profitVC.itemsStruct = itemsStruct
                profitVC.salesStruct = salesStruct
                showDetailViewController(profitVC, sender: nil)
            default:
                break
        }
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
