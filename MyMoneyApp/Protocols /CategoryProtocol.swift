//
//  CategoryProtocol.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 12.08.22.
//

import Foundation

protocol CategoryProtocol{
    var amount: Double { get }
    var imageName: String? { get }
    var name: String? { get }
    var color: String? { get }
    var spendings: NSSet? { get }
    var incomes: NSSet? { get }
    var categoryPicked : CategoryPicked? {get}
}
