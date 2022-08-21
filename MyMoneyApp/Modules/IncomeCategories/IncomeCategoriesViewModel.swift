//
//  IncomeCategoriesViewModel.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 11.08.22.
//

import Foundation

final class IncomeCategoriesViewModel{
    var categoriesStandart : [Category] = [Category(name: "Бизнес", imageName: "Бизнес", color: "155 30 82"),
                                           Category(name: "Вклады", imageName: "Вклады", color: "46 204 95"),
                                           Category(name: "Зарплата", imageName: "Зарплата", color: "187 135 54"),
                                           Category(name: "Подарки", imageName: "Подарок", color: "155 89 182"),
                                           Category(name: "Подработка", imageName: "Подработка", color: "152 159 52"),
                                           Category(name: "Сбережения", imageName: "Сбережения", color: "52 168 25")]
    
    func loadCategories() -> [IncomeCategories]?{
        let request = IncomeCategories.fetchRequest()
        var categories = try? CoreDataService.mainContext.fetch(request)
        if categories == [] {
            self.categoriesStandart.forEach { category in
                let incomeCategory = IncomeCategories(context: CoreDataService.mainContext)
                incomeCategory.name = category.name
                incomeCategory.imageName = category.imageName
                incomeCategory.amount = Double(category.spent)
                incomeCategory.color = category.color
            }
            CoreDataService.saveContext()
        }
        var updatedCategories = try? CoreDataService.mainContext.fetch(request)
        updatedCategories?.sort(by: { first, second in
            first.moneyIncome > second.moneyIncome
        })
        categories?.sort(by: { first, second in
            first.moneyIncome > second.moneyIncome
        })
        return updatedCategories ?? categories
    }
}
