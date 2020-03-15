//
//  ItemTableViewController.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 28.02.20.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit
import CoreData
class ItemTableViewController: UITableViewController {

    // add array of items
    
    var items = [Item]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        let fetchRequest = Item.fetchRequest() as NSFetchRequest<Item>
//                do {
//            items = try context.fetch(fetchRequest)
//
//        } catch let error {
//            print("Не удалось загрузить данные из-за ошибки: \(error).")
//        }
        let nib = UINib(nibName: "ItemTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ItemTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.tableView.rowHeight = 200.0
        
        reload()
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reload()
    }

    func reload() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Item.fetchRequest() as NSFetchRequest<Item>
                do {
            items = try context.fetch(fetchRequest)

        } catch let error {
            print("Eror: \(error).")
        }
        tableView.reloadData()
    }

    
   

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Мій товар"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath) as? ItemTableViewCell else { return UITableViewCell() }

        let item = items[indexPath.row]
        let imageLoad = UIImage(data: item.imageItem!)
        cell.imageItemView.image = imageLoad
        cell.titleItemLable.text = item.titleItem
        cell.categoryItemLable.text = item.categoryItem
        cell.priceItemLable.text = item.priceItem
        cell.amountItemLable.text = item.amountItem
        cell.detailsItemLable.text = item.detailsItem
        return cell
    }
    // Selected Row you see details
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "AddItemViewController") as? AddItemViewController else { return }
        _ = vc.view
        vc.isInEdit = true
        vc.titleItemTextField.text = items[indexPath.row].titleItem
        vc.categoryItemTextField.text = items[indexPath.row].categoryItem
        vc.priceItemTextField.text = items[indexPath.row].priceItem
        vc.amountItemTextField.text = items[indexPath.row].amountItem
        vc.detailsItemTextfield.text = items[indexPath.row].detailsItem
        vc.newItemLabel.text = "Твій товар"
        vc.enterImageItemLable.text = "Фото товару"
        present(vc, animated: true, completion: nil)
        }
    // Trailing swipe configutate delete  item
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Видалити") {  [weak self] (_, _, _) in
            // delete item from CoreData
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete((self?.items[indexPath.row])!)
            self?.items.remove(at: indexPath.row)
            self?.tableView.deleteRows(at:[indexPath],with: .fade)
            do{
                try context.save()
            } catch let error {
                print("Error \(error).")
            }
            self?.tableView.reloadSections([indexPath.section], with: .automatic)
            print("DELETE HAPPENS")
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        swipeActions.performsFirstActionWithFullSwipe = false
        return swipeActions
    }
}

