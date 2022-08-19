//
//  OperationCell.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 26.07.22.
//

import UIKit

class OperationCell: UITableViewCell {
    @IBOutlet private weak var categoryImage : UIImageView!
    @IBOutlet private weak var categoryName : UILabel!
    @IBOutlet private weak var accountName : UILabel!
    @IBOutlet private weak var sumLabel : UILabel!
    @IBOutlet private weak var dateLabel : UILabel!
    @IBOutlet private weak var commentLabel : UILabel!
    
    let dateFormatter = DateFormatter()
    var spending : Spending?{
        didSet{
            setupSpending()
        }
    }
    var income : Income? {
        didSet{
            setupIncome()
        }
    }
    
    private func setupSpending(){
        guard let imageName = spending?.category?.imageName else {return}
        guard let category = spending?.category?.name else {return}
        guard let account = spending?.account?.name else {return}
        guard let sum = spending?.sum else {return}
        let comment = spending?.comment
        guard let date = spending?.date else {return}
        dateFormatter.dateFormat = "dd-MMM-yy"
        dateLabel.text = dateFormatter.string(from: date)
        commentLabel.text = comment ?? ""
        categoryImage.image = UIImage(named: imageName)
        categoryName.text = category
        accountName.text = account
        sumLabel.text = " -\(String(sum)) \(spending?.account?.currencySymbol ?? "")"
        sumLabel.textColor = .red
    }
    private func setupIncome(){
        guard let imageName = income?.category?.imageName else {return}
        guard let category = income?.category?.name else {return}
        guard let account = income?.account?.name else {return}
        guard let sum = income?.sum else {return}
        let comment = income?.comment
        guard let date = income?.date else {return}
        dateFormatter.dateFormat = "dd-MMM-yy"
        dateLabel.text = dateFormatter.string(from: date)
        commentLabel.text = comment ?? ""
        categoryImage.image = UIImage(named: imageName)
        categoryName.text = category
        accountName.text = account
        sumLabel.text = " +\(String(sum)) \(income?.account?.currencySymbol ?? "")"
        sumLabel.textColor = .systemGreen
    }

}
