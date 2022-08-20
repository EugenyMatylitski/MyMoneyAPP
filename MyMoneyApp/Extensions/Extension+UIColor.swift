//
//  Extension+UIColor.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 4.08.22.
//

import Foundation
import UIKit

//MARK: much more comfortable init when we take a color with pipette tool from color cirlce

extension UIColor{
    public convenience init(r: CGFloat, g : CGFloat, b : CGFloat, alph : CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alph)
    }
}
