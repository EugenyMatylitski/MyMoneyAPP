//
//  OperationProtocol.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 12.08.22.
//

import Foundation

// MARK: - operation protocol
//protocol to reuse screen where we can use different type of operations

protocol OperationProtocol {
    var categoryPicked : CategoryPicked {get}
    var date: Date?{get set}
    var sum: Double{get set}
    var categoryName : String? {get}
    var account: Account? {get set}
    var comment : String? {get}
}
