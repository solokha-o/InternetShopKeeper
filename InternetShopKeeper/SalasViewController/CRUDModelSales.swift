//
//  CRUDModelSales.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 20.04.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CRUDModelSales {
    // fetch sale from coreData
    func fetchSale(sales: [Sales]) -> [Sales]{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        var fetchSales = sales
        let fetchRequest = Sales.fetchRequest() as NSFetchRequest<Sales>
        do {
            fetchSales = try context.fetch(fetchRequest)
        } catch let error {
            print("Error: \(error).")
        }
        return fetchSales
    }
    // add save sale to coreData
    func saveSale(sale: SalesStruct) -> Sales  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newSale = Sales(context: context)
        newSale.titleSaleItem = sale.title
        newSale.categorySaleItem = sale.category
        newSale.priseSaleItem = sale.price
        newSale.amountSaleItem = sale.amount
        newSale.imageSaleItem = sale.image.pngData()
        newSale.id = sale.id
        newSale.dateSaleItem = sale.date
            do {
                try context.save()
               } catch let error {
                print("Error \(error).")
            }
        return newSale
    }
    // update sale in coreDate
    func updateSale(sales: [Sales], id: String, sale: SalesStruct) {
        for i in sales.indices {
            if sales[i].id == id {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let fetchRequest = Sales.fetchRequest() as NSFetchRequest<Sales>
                do {
                    let updateContext = try context.fetch(fetchRequest)
                    if updateContext.count > 0 {
                        let objUpdate =  updateContext[i] as NSManagedObject
                        objUpdate.setValue(sale.title, forKey: "titleSaleItem")
                        objUpdate.setValue(sale.category, forKey: "categorySaleItem")
                        objUpdate.setValue(sale.price, forKey: "priseSaleItem")
                        objUpdate.setValue(sale.amount, forKey: "amountSaleItem")
                        objUpdate.setValue(sale.image.pngData(), forKey: "imageSaleItem")
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
    // remove sale from coreDate
    func removeSale(sale: Sales?) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        if let sale = sale {
            context.delete(sale)
        }
        do{
            try context.save()
        } catch let error {
            print("Error \(error).")
        }
    }
    // get sale from core data to array what will view in tableview
    func getAllSale(sales: [Sales]) -> [SalesStruct] {
        var salesStruct = [SalesStruct]()
        for sale in sales {
            var newSaleStruct = SalesStruct(title: "", category: "", price: "", amount: "", image: UIImage(imageLiteralResourceName: "AddImage"), id: "", date: "")
            newSaleStruct.title = sale.titleSaleItem ?? ""
            newSaleStruct.category = sale.categorySaleItem ?? ""
            newSaleStruct.price = sale.priseSaleItem ?? ""
            newSaleStruct.amount = sale.amountSaleItem ?? ""
            newSaleStruct.id = sale.id ?? ""
            newSaleStruct.image = UIImage(data: sale.imageSaleItem!)!
            newSaleStruct.date = sale.dateSaleItem ?? ""
            salesStruct.append(newSaleStruct)
        }
        return salesStruct
    }
}
