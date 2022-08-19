//
//  SpendingCategories+CoreDataProperties.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 4.08.22.
//
//

import Foundation
import CoreData


extension SpendingCategories {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SpendingCategories> {
        return NSFetchRequest<SpendingCategories>(entityName: "SpendingCategories")
    }

    @NSManaged public var amount: Double
    @NSManaged public var imageName: String?
    @NSManaged public var name: String?
    @NSManaged public var color: String?
    @NSManaged public var spendings: NSSet?

}

// MARK: Generated accessors for spendings
extension SpendingCategories {

    @objc(addSpendingsObject:)
    @NSManaged public func addToSpendings(_ value: Spending)

    @objc(removeSpendingsObject:)
    @NSManaged public func removeFromSpendings(_ value: Spending)

    @objc(addSpendings:)
    @NSManaged public func addToSpendings(_ values: NSSet)

    @objc(removeSpendings:)
    @NSManaged public func removeFromSpendings(_ values: NSSet)

}

extension SpendingCategories : Identifiable {

}

extension SpendingCategories : CategoryProtocol{
    var categoryPicked: CategoryPicked? {
        return .spending
    }
    
    public var incomes: NSSet? {
        return nil
    }
}



