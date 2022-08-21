//
//  Extension+Double.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 18.08.22.
//

import Foundation
//MARK: cutting zero in double value when we want to use it in string interpolation

extension Double{
    func formatted() -> String{
    var string = String(format: "%.2f", self)
    return string
    }
}
