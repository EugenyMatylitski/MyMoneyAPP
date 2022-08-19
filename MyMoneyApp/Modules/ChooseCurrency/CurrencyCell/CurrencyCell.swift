//
//  CurrencyCell.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 12.08.22.
//

import Foundation
import UIKit


final class CurrencyCell : UITableViewCell{
    
    static let rowHeight = 60.0
    @IBOutlet private weak var currencyName : UILabel!
    @IBOutlet private weak var currencySymbol : UILabel!
    
    var currency : Currency?{
        didSet{
            guard let currency = currency else {
                return
            }
            currencyName.text = currency.name
            currencySymbol.text = currency.symbol
        }
    }
    func hideElements(){
        currencyName.alpha = 0
        currencySymbol.alpha = 0
    }
    
    func showElements(){
        UIView.animate(withDuration: 0.2, delay: 0) {
            self.currencyName.alpha = 1
            self.currencySymbol.alpha = 1
        }
    }
}
