//
//  AddAccountVC.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 1.08.22.
//

import Foundation
import UIKit

final class AddAccountVC : UIViewController{
    @IBOutlet  weak var accountNameTextField : UITextField!
    @IBOutlet private weak var accountBalanceTextField : UITextField!
    @IBOutlet private weak var accountCommentTextView : UITextView!
    @IBOutlet private weak var titleLabel : UILabel!
    @IBOutlet private weak var chooseCurrencyButton : UIButton!
    @IBOutlet private weak var topView : UIView!
    
    var account : Account!
    var newAccount : Account?
    var topViewColor : UIColor?
    let accountsVM  = AccountsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    
    @IBAction private func deleteButtonDidTap(){
        let alert = UIAlertController(title: "Вы действительно хотите удалить счёт?", message: "восстановление данных будет невозможно", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        alert.addAction(cancelAction)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            self.accountsVM.deleteAccount(account: self.account)
            self.navigationController?.popToRootViewController(animated: true)
        }
        alert.addAction(deleteAction)
        present(alert, animated: true)
    }
    
    
    @objc private func cancelDidTap(){
        navigationController?.popToRootViewController(animated: true)
    }
    @IBAction private func chooseCurrencyDidTap(){
        let currenciesVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "\(ChooseCurrencyVC.self)") as? ChooseCurrencyVC
        currenciesVC?.delegate = self
        if self.account != nil{
            currenciesVC?.account = self.account
        } else {
            let newAccount = Account(context: CoreDataService.mainContext)
            newAccount.name = accountNameTextField.text ?? ""
            newAccount.amount = Double(accountBalanceTextField.text ?? "0") ?? 0
            currenciesVC?.account = newAccount
        }
//        currenciesVC?.topViewColor = self.topViewColor
        currenciesVC?.modalPresentationStyle = .overCurrentContext
        present(currenciesVC ?? .init(), animated: false)
    }
    
    
    @objc private func saveDidTap(){
        guard let name = accountNameTextField.text else {return}
        guard let balance = accountBalanceTextField.text else {return}
        guard let comment = accountCommentTextView.text else {return}
        if account == nil {
            if name != "" && balance != ""{
                accountsVM.saveAccount(accountName: name, accountAmount:balance, currency: nil, comment: comment, dateOfCreating : Date())
                navigationController?.popToRootViewController(animated: true)
            }
        }else{
            guard let accountToUpdate = account else {return}
            accountToUpdate.name = name
            accountToUpdate.amount = Double(balance) ?? 0.0
            accountToUpdate.comment = comment
            accountsVM.updateAccount(accountToUpdate)
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    private func setup(){
        if account != nil {
            accountNameTextField.text = account.name
            accountBalanceTextField.text = account.amount.cutZero()
            chooseCurrencyButton.setTitle("\(account.currencySymbol) (\(account.currency ?? ""))", for: .normal)
            accountCommentTextView.text = account.comment
            
        }else {
            accountNameTextField.becomeFirstResponder()
            chooseCurrencyButton.setTitle("Выбрать", for: .normal)
            self.titleLabel.text = "Новый счёт"
        }
        topView.backgroundColor = self.topViewColor
    }
    
    private func setupNavBar(){
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style:.done, target: self, action: #selector(saveDidTap))
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(cancelDidTap))
        self.navigationItem.leftBarButtonItem?.tintColor = .white
    }
}
extension AddAccountVC : SetupAccountDelegate{
    func setupAccount(account: Account) {
        self.account = account
        setup()
    }
    
    
}
