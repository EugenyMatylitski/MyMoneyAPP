//
//  CalculatorVC.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 20.07.22.
//

import Foundation
import UIKit

protocol ReloadDataDelegate{
    func reloadData()
}


final class CalculatorVC : UIViewController{
    @IBOutlet private weak var resultLabel : UILabel!
    @IBOutlet private weak var categoryLabel : UILabel!
    @IBOutlet private weak var tableView : UITableView!
    @IBOutlet private var buttons : [UIButton]!
    @IBOutlet private weak var okButton : UIButton!
    @IBOutlet private weak var backgroundView : UIView!
    @IBOutlet private weak var topView : UIView!
    @IBOutlet private weak var whichOperationLabel : UILabel!
    @IBOutlet private weak var currencyLabel : UILabel!{
        didSet{
            currencyLabel.text = ""
            currencyLabel.isHidden = true
        }
    }
    private var color : UIColor!
    var color1 : UIColor!
    var color2 : UIColor!
    let operationViewModel = OperationsViewModel()
    var delegate : ReloadDataDelegate?
    
    var accounts : [Account] = []{
        didSet {
            tableView.reloadData()
        }
    }
    
    var selectedCategory : CategoryProtocol?
    var selectedAccount : Account?
    var firstNum : Double = 0
    var operation : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = ""
        
        tableView.dataSource = self
        tableView.delegate = self 
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        setupLabels()
        fetchAccounts()
        setupColors(ofCategory: selectedCategory)
    }
    
    private func fetchAccounts(){
        let request = Account.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Account.amount), ascending: false)]
        accounts = try! CoreDataService.mainContext.fetch(request)
    }
    
    @IBAction private func numDidTap(sender : UIButton){
        resultLabel.text? += String(sender.tag)
    }
    
    @IBAction private func signDidTap(sender : UIButton){
        let tag = sender.tag
        
        if tag ==  15 && !resultLabel.text!.isEmpty {
            resultLabel.text?.removeLast()
        }else if tag == 11 || tag == 12 || tag == 13 || tag == 14  {
            firstNum += Double(resultLabel.text ?? "0") ?? 0.0
            operation = tag
            resultLabel.text = ""
        }else if tag == 16 && !(resultLabel.text?.contains("."))! && !resultLabel.text!.isEmpty{
            resultLabel.text? += "."
        }
        
        if tag == 17 && !resultLabel.text!.isEmpty && firstNum != 0{
            if operation == 11 {
                resultLabel.text = String(firstNum / Double(resultLabel.text!)!)
                operation = 0
                firstNum = 0
            }else if operation == 12{
                resultLabel.text = String(firstNum * Double(resultLabel.text!)!)
                operation = 0
                firstNum = 0
            }else if operation == 13{
                resultLabel.text = String(firstNum - Double(resultLabel.text!)!)
                operation = 0
                firstNum = 0
            }else if operation == 14 {
                resultLabel.text = String(firstNum + Double(resultLabel.text!)!)
                operation = 0
                firstNum = 0
            }
        }
    }
    
    @IBAction private func okDidTap(){
        guard let sum = Double(resultLabel.text ?? "") else {return}
        guard let selectedCategory = selectedCategory else {return}
        guard let selectedAccount = selectedAccount else {return}
        switch self.selectedCategory?.categoryPicked{
        case .spending : operationViewModel.saveSpendingOperation(sum: sum, catgegory: selectedCategory, account: selectedAccount)
        case .income : operationViewModel.saveIncomeOperation(sum: sum, catgegory: selectedCategory, account: selectedAccount)
        case .none:
            break
        }
        
        delegate?.reloadData()
        dismiss(animated: true)
    }
    
    
    private func setupColors(ofCategory : CategoryProtocol?){
        let splitedString = ofCategory?.color?.split(separator: " ")
        let red = CGFloat(Double((splitedString?.first)!) ?? 0.0)
        let green = CGFloat(Double((splitedString?[1])!) ?? 0.0)
        let blue = CGFloat(Double((splitedString?.last)!) ?? 0.0)
        let color = UIColor(r: red, g: green, b: blue, alph: 1.0)
        buttons.forEach { button in
            button.tintColor = color
        }
        self.color = color
        okButton.backgroundColor = color
        backgroundView.backgroundColor = color.withAlphaComponent(0.1)
        categoryLabel.textColor = .white
        categoryLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        topView.backgroundColor = color
    }
    private func setupLabels(){
        switch self.selectedCategory?.categoryPicked{
        case .income:
            categoryLabel.text = "Доход по категории \(selectedCategory?.name ?? "")"
            whichOperationLabel.text = "Доход"
        case .spending:
            categoryLabel.text = "Расход по категории \(selectedCategory?.name ?? "")"
            whichOperationLabel.text = "Расход"
        case .none: break
        }
    }
    @IBAction private func exitButtonDidTap(){
        dismiss(animated: true)
    }
    
}

extension CalculatorVC : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(AccountCell.self)")
        as? AccountCell
        cell?.setup(account: accounts[indexPath.row])
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AccountCell.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(AccountCell.self)") as? AccountCell else {return}
        currencyLabel.isHidden = false
        currencyLabel.text = accounts[indexPath.row].currencySymbol
        self.selectedAccount = accounts[indexPath.row]
    }
}



