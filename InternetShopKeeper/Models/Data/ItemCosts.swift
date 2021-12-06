//
//  ItemCosts.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 06.04.2021.
//  Copyright © 2021 Oleksandr Solokha. All rights reserved.
//

import Foundation
import CoreData

class ItemCosts: NSManagedObject, Identifiable{
    @NSManaged public var price : String?
    @NSManaged public var amount : String?
    @NSManaged public var id: String?
    @NSManaged public var date: String?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemCosts> {
        return NSFetchRequest<ItemCosts>(entityName: "ItemCosts")
    }
}
