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
    
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRequest()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        setupCostsLabel()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRequest()
    }
    
    // fetch request from coreData
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
    // calculation costs buying item
    func costCalculation (items: [Item]) -> String {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
