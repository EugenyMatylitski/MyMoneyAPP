//
//  AccountsViewModel.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 1.08.22.
//

import Foundation
import UIKit
import CoreData

final class AccountsViewModel{
    let context = CoreDataService.mainContext
    
    var dateOfcreating : Date?
    
    func saveAccount(accountName : String, accountAmount : String, currency : String?, comment : String?, dateOfCreating : Date){
        guard let accountAmount = Double(accountAmount) else {return}
        CoreDataService.mainContext.perform {
            let account = Account(context: self.context)
            account.name = accountName
            account.amount = accountAmount
            account.comment = comment
            account.dateOfCreating = dateOfCreating
            CoreDataService.saveContext()
        }
    }
    func updateAccount(_ account : Account){
        CoreDataService.mainContext.perform {
            CoreDataService.saveContext()
        }
        
    }
    
    func deleteAccount(account : Account){
        self.context.delete(account)
        CoreDataService.saveContext()
    }
    
    
}
