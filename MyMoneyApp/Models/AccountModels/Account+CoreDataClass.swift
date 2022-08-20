//
//  Account+CoreDataClass.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 3.08.22.
//
//

import Foundation
import CoreData

@objc(Account)
public class Account: NSManagedObject {
    
    var allIncomes : [Income]{
        return incomes?.allObjects as? [Income] ?? []
    }
    
// Returns symbol of choosing currency
    
    var currencySymbol : String {
        switch self.currency{
        case "eur": return "\u{20AC}"
        case "byn": return "BYN"
        case "usd": return "\u{0024}"
        default : return ""
        }
    }
}
