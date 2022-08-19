//
//  EditingViewModel.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 16.08.22.
//

import Foundation

final class EditingViewModel {
    var spending : Spending?
    var income : Income?
    func loadSpendingCategories() -> [SpendingCategories]?{
        let request = SpendingCategories.fetchRequest()
        let categories = try? CoreDataService.mainContext.fetch(request)
        return  categories
    }
    
    func loadIncomeCategories() -> [IncomeCategories]?{
        let request = IncomeCategories.fetchRequest()
        let categories = try? CoreDataService.mainContext.fetch(request)
        return  categories
    }
    
    func updateCategory(category : CategoryProtocol, operation : OperationProtocol) -> OperationProtocol{
        switch operation.categoryPicked {
        case .spending :
            spending = operation as? Spending
            let newCategory = category as? SpendingCategories
            spending?.category = newCategory
            CoreDataService.saveContext()
            return spending ?? .init()
        case .income :
            income = operation as? Income
            let newCategory = category as? IncomeCategories
            income?.category = newCategory
            CoreDataService.saveContext()
            return income ?? .init()
        }
    }
    
    func deleteOperation(operation : OperationProtocol){
        switch operation.categoryPicked{
        case .spending:
            let account = operation.account
            account?.amount += operation.sum
            CoreDataService.mainContext.delete(operation as! Spending)
            CoreDataService.saveContext()
        case .income :
            let account = operation.account
            account?.amount -= operation.sum
            CoreDataService.mainContext.delete(operation as! Income)
            CoreDataService.saveContext()
        }
    }
    
    func saveAccount(oldAccount : Account , newAccount : Account, operation : OperationProtocol) -> OperationProtocol{
        var newAccount1 = newAccount
        var oldAccount1 = oldAccount
        switch operation.categoryPicked {
        case .spending :
            spending = operation as? Spending
            spending?.account = newAccount
            newAccount1.amount -= spending?.sum ?? 0.0
            oldAccount1.amount += spending?.sum ?? 0.0
            CoreDataService.saveContext()
            return spending ?? .init()
        case .income :
            income = operation as? Income
            income?.account = newAccount
            newAccount1.amount += income?.sum ?? 0.0
            oldAccount1.amount -= income?.sum ?? 0.0
            CoreDataService.saveContext()
            return income ?? .init()
        }
    }
    
    func saveNewSum(operation : OperationProtocol,account : Account, newSum : Double) -> OperationProtocol{
        let account = account
        switch operation.categoryPicked {
        case .spending :
            spending = operation as? Spending
            account.amount += spending?.sum ?? 0.0
            account.amount -= newSum
            spending?.sum = newSum
            CoreDataService.saveContext()
            return spending ?? .init()
        case .income :
            income = operation as? Income
            account.amount -= income?.sum ?? 0.0
            account.amount += newSum
            income?.sum = newSum
            CoreDataService.saveContext()
            return income ?? .init()
        }
    }
    
    func saveNewDate(operation : OperationProtocol, date : Date) -> OperationProtocol{
        switch operation.categoryPicked {
        case .spending :
            spending = operation as? Spending
            spending?.date = date
            CoreDataService.saveContext()
            return spending ?? .init()
        case .income :
            income = operation as? Income
            income?.date = date
            CoreDataService.saveContext()
            return income ?? .init()
        }
    }
    
    func saveNewComment(operation : OperationProtocol, comment : String) -> OperationProtocol {
        switch operation.categoryPicked {
        case .spending :
            spending = operation as? Spending
            spending?.comment = comment
            CoreDataService.saveContext()
            return spending ?? .init()
        case .income :
            income = operation as? Income
            income?.comment = comment
            CoreDataService.saveContext()
            return income ?? .init()
        }
    }
}
