//
//  Extension+Double.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 18.08.22.
//

import Foundation

extension Double{
    func cutZero() -> String{
    var string = String(format: "%g", self)
    return string
    }
}
