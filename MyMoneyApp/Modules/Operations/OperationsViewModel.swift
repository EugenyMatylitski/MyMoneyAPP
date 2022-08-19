//
//  OperationsViewModel.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 9.08.22.
//

import Foundation

final class OperationsViewModel{
    func saveSpendingOperation(sum : Double, catgegory : CategoryProtocol, account : Account){
            let spending = Spending(context: CoreDataService.mainContext)
            spending.sum = sum
            spending.category = catgegory as? SpendingCategories
            spending.account = account
            spending.date = Date()
            spending.account?.amount -= sum
        CoreDataService.saveContext()
    }
    func saveIncomeOperation(sum : Double, catgegory : CategoryProtocol, account : Account){
            let income = Income(context: CoreDataService.mainContext)
        income.sum = sum
        income.category = catgegory as? IncomeCategories
        income.account = account
        income.date = Date()
        income.account?.amount += sum
        CoreDataService.saveContext()
    }
    
    func loadSpendingOperations() -> [Spending]{
        let request = Spending.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Spending.date), ascending: false)]
        let spendings = try? CoreDataService.mainContext.fetch(request)
        return spendings ?? []
    }
    
    func loadIncomeOperations() -> [Income]{
        let request = Income.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Income.date), ascending: false)]
        let incomes = try? CoreDataService.mainContext.fetch(request)
        return incomes ?? []
    }
    
    func loadSpendingDateFilteredOperations(date : Date, number : Int) -> [Spending]{
        let request = Spending.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Spending.date), ascending: false)]
        let spendings = try? CoreDataService.mainContext.fetch(request)
        let day = Calendar.current.component(.day, from: date)
        let week = Calendar.current.component(.weekOfYear, from: date)
        let month = Calendar.current.component(.month, from: date)
        let year = Calendar.current.component(.year, from: date)
        var filteredSpendings = spendings?.filter({ spending in
            let spendingDay = Calendar.current.component(.day, from: spending.date!)
            let spendingWeek = Calendar.current.component(.weekOfYear, from: spending.date!)
            let spendingMonth = Calendar.current.component(.month, from: spending.date!)
            let spendingYear = Calendar.current.component(.year, from: spending.date!)
            switch number{
            case 1: return (day == spendingDay) && (year == spendingYear)
            case 2: return (week == spendingWeek) && (year == spendingYear)
            case 3: return (month == spendingMonth) && (year == spendingYear)
            default : return false
            }
        })
        if number == 0 {
            return spendings ?? []
        }
        return filteredSpendings ?? []
    }
    
    func loadIncomeDateFilteredOperations(date : Date, number : Int) -> [Income]{
        let request = Income.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Income.date), ascending: false)]
        let incomes = try? CoreDataService.mainContext.fetch(request)
        let day = Calendar.current.component(.day, from: date)
        let week = Calendar.current.component(.weekOfYear, from: date)
        let month = Calendar.current.component(.month, from: date)
        let year = Calendar.current.component(.year, from: date)
        var filteredIncomes = incomes?.filter({ income in
            let incomeDay = Calendar.current.component(.day, from: income.date!)
            let incomeWeek = Calendar.current.component(.weekOfYear, from: income.date!)
            let incomeMonth = Calendar.current.component(.month, from: income.date!)
            let incomeYear = Calendar.current.component(.year, from: income.date!)
            switch number{
            case 1: return (day == incomeDay) && (week == incomeWeek)
            case 2: return (week == incomeWeek) && (year == incomeYear)
            case 3: return (month == incomeMonth) && (year == incomeYear)
            default : return false
            }
        })
        if number == 0 {
            return incomes ?? []
        }
        return filteredIncomes ?? []
    }
    
    
    
}
