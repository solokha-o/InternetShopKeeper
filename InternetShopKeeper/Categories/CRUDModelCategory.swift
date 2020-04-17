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
    
}
