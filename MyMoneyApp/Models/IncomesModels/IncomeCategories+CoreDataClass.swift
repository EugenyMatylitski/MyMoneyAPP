//
//  IncomeCategories+CoreDataClass.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 3.08.22.
//
//

import Foundation
import CoreData

@objc(IncomeCategories)
public class IncomeCategories: NSManagedObject {
    var allIncomes : [Income]{
        return incomes?.allObjects as? [Income] ?? []
    }
    var moneyIncome : Double{
        var moneyIncome : Double = 0.0
        allIncomes.forEach { income in
            moneyIncome += income.sum
        }
        return moneyIncome
    }
}
