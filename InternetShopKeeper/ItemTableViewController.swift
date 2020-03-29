//
//  ItemTableViewController.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 28.02.20.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit
import CoreData
import DropDown

class ItemTableViewController: UITableViewController {

    @IBOutlet weak var sortButtonOutlet: UIBarButtonItem!
    
    // cteate dropDown barButtonItem
    let leftBarDropDown = DropDown()
    // add array of items
        var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // configurate BarButtonItem DropDown
        leftBarDropDown.anchorView = sortButtonOutlet
        leftBarDropDown.dataSource = ["Сортувати товари по назві А - Я", "Сортувати товари по назві Я - А"]
        leftBarDropDown.cellConfiguration = { (index, item) in return "\(item)" }
        leftBarDropDown.cornerRadius = 10
        leftBarDropDown.shadowColor = UIColor.black
        leftBarDropDown.shadowOpacity = 0.8
        navigationController?.navigationBar.prefersLargeTitles = true
        let nib = UINib(nibName: "ItemTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ItemTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
//        self.tableView.rowHeight = 160.0
        reloadItemTableViewController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadItemTableViewController()
    }
    // reload tableview and fetch CoreData
    func reloadItemTableViewController() {
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
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
        vc.detailsItemTextView.text = items[indexPath.row].detailsItem
        let imageLoad = UIImage(data: items[indexPath.row].imageItem!)
        vc.addImage.isHighlighted = false
        vc.addImage.image = imageLoad
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
    @IBAction func sortButtonAction(_ sender: UIBarButtonItem) {
        // filter items by select item of dropDown
        leftBarDropDown.selectionAction = { (index: Int, item: String) in
            switch index {
            case 0:
                self.items = self.items.sorted {$0.titleItem!.lowercased() < $1.titleItem!.lowercased()}
                self.tableView.reloadData()
                print(self.items)
            case 1:
                self.items = self.items.sorted {$0.titleItem!.lowercased() > $1.titleItem!.lowercased()}
                self.tableView.reloadData()
                print(self.items)
            default: break
            }
          print("Selected item: \(item) at index: \(index)") }
        leftBarDropDown.width = 250
        leftBarDropDown.bottomOffset = CGPoint(x: 0, y:(leftBarDropDown.anchorView?.plainView.bounds.height)!)
        leftBarDropDown.show()
        leftBarDropDown.dismissMode = .onTap
    }
    
}

