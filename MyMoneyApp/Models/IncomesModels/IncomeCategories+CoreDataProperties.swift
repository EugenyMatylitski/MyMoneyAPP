//
//  IncomeCategories+CoreDataProperties.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 12.08.22.
//
//

import Foundation
import CoreData


extension IncomeCategories {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<IncomeCategories> {
        return NSFetchRequest<IncomeCategories>(entityName: "IncomeCategories")
    }

    @NSManaged public var amount: Double
    @NSManaged public var imageName: String?
    @NSManaged public var name: String?
    @NSManaged public var color: String?
    @NSManaged public var incomes: NSSet?

}

// MARK: Generated accessors for incomes
extension IncomeCategories {

    @objc(addIncomesObject:)
    @NSManaged public func addToIncomes(_ value: Income)

    @objc(removeIncomesObject:)
    @NSManaged public func removeFromIncomes(_ value: Income)

    @objc(addIncomes:)
    @NSManaged public func addToIncomes(_ values: NSSet)

    @objc(removeIncomes:)
    @NSManaged public func removeFromIncomes(_ values: NSSet)

}

extension IncomeCategories : Identifiable {

}
extension IncomeCategories : CategoryProtocol{
    var categoryPicked: CategoryPicked? {
        return .income
    }
    
    public var spendings: NSSet? {
        return nil
    }
}
