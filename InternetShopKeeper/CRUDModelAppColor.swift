//
//  CRUDModelAppColor.swift
//  InternetShopKeeper
//
//  Created by Oleksandr Solokha on 25.05.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CRUDModelAppColor {
    // fetch color from coreData
    func fetchColor(color: [AppColor]) -> [AppColor] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        var fetchColor = color
        let fetchRequest = AppColor.fetchRequest() as NSFetchRequest<AppColor>
        do {
            fetchColor = try context.fetch(fetchRequest)
        } catch let error {
            print("Error: \(error)")
        }
        return fetchColor
    }
    // add save color to coreData
    func saveColor(color: UIColor)  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newColor = AppColor(context: context)
        newColor.color = UIColor.stringFromUIColor(color: color)
        do {
            try context.save()
        } catch let error {
            print("Error \(error).")
        }
    }
    // update color in coreDate
    func updateColor(color: UIColor) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = AppColor.fetchRequest() as NSFetchRequest<AppColor>
        do {
            let updateContext = try context.fetch(fetchRequest)
            if updateContext.count > 0 {
                let objUpdate =  updateContext[0] as NSManagedObject
                let updateColor = UIColor.stringFromUIColor(color: color)
                objUpdate.setValue(updateColor, forKey: "color")
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

// convert UIColor to String and Sring to UIColor
public extension UIColor {
    class func stringFromUIColor(color: UIColor) -> String {
        var components = color.cgColor.components
        if components!.count <= 2 {
            components?.append(0.0)
            components?.append(0.0)
        }
        let stringColor = "\(components?[0] ?? 0.0), \(components?[1] ?? 0.0), \(components?[2] ?? 0.0), \(components?[3] ?? 0.0)"
        print(stringColor)
        return stringColor
    }
    
    class func uiColorFromString(string: String) -> UIColor {
        let components = string.components(separatedBy: ",")
        let colorString = UIColor(red: CGFloat((components[0] as NSString).floatValue),
                                  green: CGFloat((components[1] as NSString).floatValue),
                                  blue: CGFloat((components[2] as NSString).floatValue),
                                  alpha: CGFloat((components[3] as NSString).floatValue))
        print(colorString)
        return colorString
    }
}
