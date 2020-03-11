//
//  CategoryTableViewController.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 09.03.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var items = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        let fetchRequest = Item.fetchRequest() as NSFetchRequest<Item>
//                do {
//            categories = try context.fetch(fetchRequest)
//
//        } catch let error {
//            print("Не удалось загрузить данные из-за ошибки: \(error).")
//        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
//      tableView.reloadData()
        reload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reload()
        tableView.reloadData()
    }
    
    func reload() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Item.fetchRequest() as NSFetchRequest<Item>
                do {
            items = try context.fetch(fetchRequest)

        } catch let error {
            print("Не удалось загрузить данные из-за ошибки: \(error).")
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    // configurate cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let category = items[indexPath.row]
        cell.textLabel?.text = category.categoryItem
   //     cell.detailTextLabel?.text = "Категорія товару"
        return cell
    }
    // Selected Row you see details 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = items[indexPath.row]
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "AddCategoryViewController") as? AddCategoryViewController else { return }
        _ = vc.view
        vc.addCategoryTextField.text = category.categoryItem
        vc.saveCategoryButtonOutlet.isHidden = true
        vc.saveCategoryButtonOutlet.isHidden = true
        vc.newCategoryLable.text = "Категорія товару"
        vc.enterCategoryLable.text = "Створена категорія товару"
        vc.addCategoryTextField.isUserInteractionEnabled = false
        present(vc, animated: true, completion: nil)
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
