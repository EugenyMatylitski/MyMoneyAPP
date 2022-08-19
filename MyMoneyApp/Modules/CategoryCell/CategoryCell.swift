//
//  CategoryCell.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 20.07.22.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    @IBOutlet private weak var categoryNameLabel : UILabel!
    @IBOutlet private weak var categoryImage : UIImageView!
    @IBOutlet private weak var bynLabel : UILabel!
    @IBOutlet private weak var eurLabel : UILabel!
    @IBOutlet private weak var usdLabel : UILabel!
    var operation : OperationProtocol!
    
    func hideElements(){
        categoryImage.alpha = 0
        categoryNameLabel.alpha = 0
    }
    func showElements(){
        UIView.animate(withDuration: 0.2, delay: 0) {
            self.categoryImage.alpha = 1
            self.categoryNameLabel.alpha = 1
        }
    }
    
    func setupSpending(category : SpendingCategories, spendings : [Spending]){
        categoryNameLabel.text = category.name
        categoryImage.image = UIImage(named: category.imageName ?? "") ?? .init()
        var bynSpending : Double = 0.0
        var eurSpending : Double = 0.0
        var usdSpending : Double = 0.0
        spendings.forEach { spending in
            if spending.account?.currency == "byn"{
                bynSpending += spending.sum
            }else if spending.account?.currency == "eur"{
                eurSpending += spending.sum
            }else{
                usdSpending += spending.sum
            }
            
        }
        bynLabel.text = "\(bynSpending.cutZero()) BYN "
        eurLabel.text = "\(eurSpending.cutZero()) \u{20AC}"
        usdLabel.text = "\(usdSpending.cutZero()) \u{0024}"
    }
    
    func setupIncomes(category : IncomeCategories, incomes : [Income]){
        categoryNameLabel.text = category.name
        categoryImage.image = UIImage(named: category.imageName ?? "") ?? .init()
        var bynIncome : Double = 0.0
        var eurIncome : Double = 0.0
        var usdIncome : Double = 0.0
        incomes.forEach { income in
            if income.account?.currency == "byn"{
                bynIncome += income.sum
            }else if income.account?.currency == "eur"{
                eurIncome += income.sum
            }else{
                usdIncome += income.sum
            }
            
        }
        bynLabel.text = "\(bynIncome) Byn"
        eurLabel.text = "\(eurIncome) \u{20AC}"
        usdLabel.text = "\(usdIncome) \u{0024}"
    }
    
    func setupSpendingsForEdit(category : SpendingCategories){
        categoryNameLabel.text = category.name
        categoryImage.image = UIImage(named: category.imageName ?? "") ?? .init()
    }
    func setupIncomesForEdit(category : IncomeCategories){
        categoryNameLabel.text = category.name
        categoryImage.image = UIImage(named: category.imageName ?? "") ?? .init()
    }
}
