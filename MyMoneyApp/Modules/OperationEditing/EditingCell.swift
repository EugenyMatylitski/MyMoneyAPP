//
//  Cell.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 15.08.22.
//

import Foundation
import UIKit

final class EditingCell : UITableViewCell{
    @IBOutlet weak var fieldNameLabel : UILabel!
    @IBOutlet weak var currentValueLabel : UILabel!
    
    static let rowHeight = 50.0
    var currentValueColor : UIColor?{
        didSet{
            currentValueLabel.textColor = currentValueColor
        }
    }
    var commentColor : UIColor?{
        didSet {
            currentValueLabel.textColor = commentColor
        }
    }
    var fieldName : String?{
        didSet{
            fieldNameLabel.text = fieldName
        }
    }
    var currentValue : String?{
        didSet{
            currentValueLabel.text = currentValue
        }
    }
}
