//
//  StatisticTableViewController.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 27.04.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit

class StatisticTableViewController: UITableViewController {
    
    
    // create array Item
    var itemsStract = [ItemStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.title = "Статистика".localized
        navigationItem.title = "Статистика".localized
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
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
            cell.textLabel?.text = "Твої витрати"
            cell.detailTextLabel?.text = "Витрати, що зроблені на закупівлю товару"
        case 1:
            cell.textLabel?.text = "Твій прибуток"
            cell.detailTextLabel?.text = "Інформація щодо прибутку від продажу товару"
        case 2:
            cell.textLabel?.text = "Чистий дохід"
            cell.detailTextLabel?.text = "Вирахування чистого доходу від продажу товару"
        default:
            break
        }
        return cell
    }
    // configure didSelectRowAt
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let costsVC = storyboard?.instantiateViewController(identifier: "CostsViewController") as? CostsViewController else { return }
        switch indexPath.row {
        case 0:
            costsVC.itemsStruct = itemsStract
            showDetailViewController(costsVC, sender: nil)
        default:
            break
        }
    }
    
}
