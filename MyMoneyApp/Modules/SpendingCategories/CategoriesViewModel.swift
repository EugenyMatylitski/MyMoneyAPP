//
//  CategoriesVCModel.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 3.08.22.
//

import Foundation
import UIKit

final class CategoriesVCModel {
    var categoriesStandart : [Category] = [Category(name: "Семья", imageName: "Семья", color: "148 114 213"),
                                           Category(name: "Транспорт", imageName: "Транспорт", color: "255 189 11"),
                                           Category(name: "Спорт", imageName: "Спорт", color: "96 185 164"),
                                           Category(name: "Связь", imageName: "Связь", color: "184 145 222"),
                                           Category(name: "Продукты", imageName: "Продукты", color: "44 196 241"),
                                           Category(name: "Подарки", imageName: "Подарки", color: "250 87 46"),
                                           Category(name: "Питомцы", imageName: "Питомцы", color: "141 145 66"),
                                           Category(name: "Одежда", imageName: "Одежда", color: "54 32 255"),
                                           Category(name: "Кафе", imageName: "Кафе", color: "65 98 190"),
                                           Category(name: "Здоровье", imageName: "Здоровье", color: "95 210 139"),
                                           Category(name: "Жильё", imageName: "Жильё", color: "72 156 166"),
                                           Category(name: "Досуг", imageName: "Досуг", color: "248 6 104")]
    
    func loadCategories() -> [SpendingCategories]?{
        let request = SpendingCategories.fetchRequest()
        var categories = try? CoreDataService.mainContext.fetch(request)
        if categories == [] {
            self.categoriesStandart.forEach { category in
                let spendingCategory = SpendingCategories(context: CoreDataService.mainContext)
                spendingCategory.name = category.name
                spendingCategory.imageName = category.imageName
                spendingCategory.amount = Double(category.spent)
                spendingCategory.color = category.color
            }
            CoreDataService.saveContext()
        }
        

        var updatedCategories = try? CoreDataService.mainContext.fetch(request)
        updatedCategories?.sort(by: { first, second in
            first.moneySpent > second.moneySpent
        })
        categories?.sort(by: { first, second in
            first.moneySpent > second.moneySpent
        })
        return updatedCategories ?? categories
    }
}
