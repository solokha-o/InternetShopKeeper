//
//  CRUDModelCategory.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 16.04.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CRUDModelCategory {
    
    // fetch category from coreData
    func fetchCategory(categories: [Categories]) -> [Categories]{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        var fetchCategories = categories
        let fetchRequest = Categories.fetchRequest() as NSFetchRequest<Categories>
        do {
            fetchCategories = try context.fetch(fetchRequest)
        } catch let error {
            print("Error: \(error).")
        }
        return fetchCategories
    }
    // add save category to coreData
    func saveCategory(category: CategoryStruct) -> Categories {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newCategory = Categories(context: context)
        newCategory.name = category.name
        newCategory.id = category.id
            do {
                try context.save()
               } catch let error {
                print("Error \(error).")
            }
        return newCategory
    }
    
    // update category in coreDate
    func updateCategory(categories: [Categories], id: String, category: CategoryStruct) {
        for i in 0..<categories.count {
            if categories[i].id == id {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let fetchRequest = Categories.fetchRequest() as NSFetchRequest<Categories>
                do {
                    let updateContext = try context.fetch(fetchRequest)
                    if updateContext.count > 0 {
                        let objUpdate =  updateContext[i] as NSManagedObject
                        objUpdate.setValue(category.name, forKey: "name")
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
    // remove category from coreDate
    func removeCategory(category: Categories?) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        if let category = category {
            context.delete(category)
        }
        do{
            try context.save()
        } catch let error {
            print("Error \(error).")
        }
    }
    // get category from core data to array what will view in tableview
    func getAllCategory(categories: [Categories]) -> [CategoryStruct] {
        var categoriesStruct = [CategoryStruct]()
        for category in categories {
            var newCategoryStruct = CategoryStruct(name: "", id: "")
            newCategoryStruct.name = category.name ?? ""
            newCategoryStruct.id = category.id ?? ""
            categoriesStruct.append(newCategoryStruct)
        }
        return categoriesStruct
    }
    // get category for id from coreData
    func getIdCategory() {
        //TODO: this function is not using now
    }
}
