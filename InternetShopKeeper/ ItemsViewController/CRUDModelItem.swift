//
//  CRUDModelItem.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 18.04.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CRUDModelItem {
    // fetch item from coreData
    func fetchItem(items: [Item]) -> [Item]{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        var fetchItems = items
        let fetchRequest = Item.fetchRequest() as NSFetchRequest<Item>
        do {
            fetchItems = try context.fetch(fetchRequest)
        } catch let error {
            print("Error: \(error).")
        }
        return fetchItems
    }
    // add save Item to coreData
    func saveItem(item: ItemStruct) -> Item  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newItem = Item(context: context)
        newItem.titleItem = item.title
        newItem.categoryItem = item.category
        newItem.priceItem = item.price
        newItem.amountItem = item.amount
        newItem.detailsItem = item.details
        newItem.incomePriceItem = item.incomePrice
        newItem.imageItem = item.image.pngData()
        newItem.id = item.id
        newItem.dateItem = item.date
        do {
            try context.save()
        } catch let error {
            print("Error \(error).")
        }
        return newItem
    }
    // update item in coreDate
    func updateItem(items: [Item], id: String, item: ItemStruct) {
        for i in 0..<items.count {
            if items[i].id == id {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let fetchRequest = Item.fetchRequest() as NSFetchRequest<Item>
                do {
                    let updateContext = try context.fetch(fetchRequest)
                    if updateContext.count > 0 {
                        let objUpdate =  updateContext[i] as NSManagedObject
                        objUpdate.setValue(item.title, forKey: "titleItem")
                        objUpdate.setValue(item.category, forKey: "categoryItem")
                        objUpdate.setValue(item.price, forKey: "priceItem")
                        objUpdate.setValue(item.amount, forKey: "amountItem")
                        objUpdate.setValue(item.details, forKey: "detailsItem")
                        objUpdate.setValue(item.incomePrice, forKey: "incomePriceItem")
                        objUpdate.setValue(item.image.pngData(), forKey: "imageItem")
                        do {
                            try context.save()
                        } catch let error {
                            print("Error \(error).")
                        }
                    }
                } catch let error {
                    print("Error \(error).")
                }
            }
        }
    }
    // remove item from coreDate
    func removeItem(item: Item?) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        if let item = item {
            context.delete(item)
        }
        do{
            try context.save()
        } catch let error {
            print("Error \(error).")
        }
    }
    // get item from core data to array what will view in tableview
    func getAllItem(items: [Item]) -> [ItemStruct] {
        var itemsStruct = [ItemStruct]()
        for item in items {
            var newItemStruct = ItemStruct(title: "", category: "", price: "", amount: "", details: "", image: UIImage(imageLiteralResourceName: "AddImage"), id: "", incomePrice: "", date: "")
            newItemStruct.title = item.titleItem ?? ""
            newItemStruct.category = item.categoryItem ?? ""
            newItemStruct.price = item.priceItem ?? ""
            newItemStruct.amount = item.amountItem ?? ""
            newItemStruct.details = item.detailsItem ?? ""
            newItemStruct.incomePrice = item.incomePriceItem ?? ""
            newItemStruct.id = item.id ?? ""
            newItemStruct.image = UIImage(data: item.imageItem!)!
            newItemStruct.date = item.dateItem ?? ""
            itemsStruct.append(newItemStruct)
        }
        return itemsStruct
    }
}
