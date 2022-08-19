//
//  Spending+CoreDataProperties.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 18.08.22.
//
//

import Foundation
import CoreData


extension Spending {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Spending> {
        return NSFetchRequest<Spending>(entityName: "Spending")
    }

    @NSManaged public var date: Date?
    @NSManaged public var sum: Double
    @NSManaged public var comment: String?
    @NSManaged public var account: Account?
    @NSManaged public var category: SpendingCategories?

}

extension Spending : Identifiable {

}

extension Spending : OperationProtocol{
    var categoryPicked: CategoryPicked {
        return .spending
    }
    var categoryName: String?{
        return category?.name
    }
}
