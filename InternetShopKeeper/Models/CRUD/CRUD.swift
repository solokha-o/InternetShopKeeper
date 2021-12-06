//
//  CRUD.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 08.04.2021.
//  Copyright © 2021 Oleksandr Solokha. All rights reserved.
//

import Foundation
import CoreData
import UIKit
 
class CRUD {
    // fetch item from coreData
    func fetch<T: NSFetchRequestResult>(from dataModel: [T], with entityName: String) -> [T]{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        var fetchDataModel = dataModel
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        do {
            fetchDataModel = try context.fetch(fetchRequest)
        } catch let error {
            print("Error: \(error).")
        }
        return fetchDataModel
    }
    
    
    
    
    
    
    
    // add save Item to coreData
    func save(to dataModel: ItemStruct) -> Item  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newItem = Item(context: context)
        newItem.titleItem = dataModel.title
        newItem.categoryItem = dataModel.category
        newItem.priceItem = dataModel.price
        newItem.amountItem = dataModel.amount
        newItem.detailsItem = dataModel.details
        newItem.incomePriceItem = dataModel.incomePrice
        newItem.imageItem = dataModel.image.pngData()
        newItem.id = dataModel.id
        newItem.dateItem = dataModel.date
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
