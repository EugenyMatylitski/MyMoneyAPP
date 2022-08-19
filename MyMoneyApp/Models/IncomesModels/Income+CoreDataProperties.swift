//
//  Income+CoreDataProperties.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 18.08.22.
//
//

import Foundation
import CoreData


extension Income {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Income> {
        return NSFetchRequest<Income>(entityName: "Income")
    }

    @NSManaged public var date: Date?
    @NSManaged public var sum: Double
    @NSManaged public var comment: String?
    @NSManaged public var account: Account?
    @NSManaged public var category: IncomeCategories?

}

extension Income : Identifiable {

}

extension Income : OperationProtocol{
    var categoryPicked: CategoryPicked {
        return .income
    }
    var categoryName: String?{
        return category?.name
    }
}
