//
//  SpendingCategories+CoreDataClass.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 3.08.22.
//
//

import Foundation
import CoreData

@objc(SpendingCategories)
public class SpendingCategories: NSManagedObject {
    

    var allSpendings : [Spending]{
        return spendings?.allObjects as? [Spending] ?? []
    }
    
//Property to be able to count sum of all expences
    var moneySpent : Double{
        var moneySpent : Double = 0.0
        allSpendings.forEach { spending in
            moneySpent += spending.sum
        }
        return moneySpent
    }
    var whichCategory = CategoryPicked.spending
}
