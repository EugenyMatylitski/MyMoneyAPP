//
//  Account+CoreDataProperties.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 12.08.22.
//
//

import Foundation
import CoreData


extension Account {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var amount: Double
    @NSManaged public var comment: String?
    @NSManaged public var currency: String?
    @NSManaged public var dateOfCreating: Date?
    @NSManaged public var name: String?
    @NSManaged public var spendings: NSSet?
    @NSManaged public var incomes: NSSet?

}

// MARK: Generated accessors for spendings
extension Account {

    @objc(addSpendingsObject:)
    @NSManaged public func addToSpendings(_ value: Spending)

    @objc(removeSpendingsObject:)
    @NSManaged public func removeFromSpendings(_ value: Spending)

    @objc(addSpendings:)
    @NSManaged public func addToSpendings(_ values: NSSet)

    @objc(removeSpendings:)
    @NSManaged public func removeFromSpendings(_ values: NSSet)

}

// MARK: Generated accessors for incomes
extension Account {

    @objc(addIncomesObject:)
    @NSManaged public func addToIncomes(_ value: Income)

    @objc(removeIncomesObject:)
    @NSManaged public func removeFromIncomes(_ value: Income)

    @objc(addIncomes:)
    @NSManaged public func addToIncomes(_ values: NSSet)

    @objc(removeIncomes:)
    @NSManaged public func removeFromIncomes(_ values: NSSet)

}

extension Account : Identifiable {

}
