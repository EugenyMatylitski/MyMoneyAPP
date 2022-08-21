//
//  AccountCell.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 26.07.22.
//

import UIKit

class AccountCell: UITableViewCell {
    @IBOutlet private weak var accountName : UILabel!
    @IBOutlet private weak var accountAmount : UILabel!
    static let rowHeight : CGFloat = 75
    func setup (account : Account){
        
        self.accountName.text = account.name
        self.accountAmount.text = "\(account.amount) \(account.currencySymbol ?? "")"
    }
}
