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
    
    
    var oldAccount : Account?{
        didSet{
            oldAccountValues.name = oldAccount?.name
            oldAccountValues.amount = oldAccount?.amount
            oldAccountValues.currency = oldAccount?.currency
            oldAccountValues.comment = oldAccount?.comment
        }
    }
    var oldAccountValues = AccountStruct()
    var newAccount : Account?
    var notSavedAccount : Account?
    var topViewColor : UIColor?
    let accountsVM  = AccountsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setup(account: oldAccount)
    }
    
    @IBAction private func deleteButtonDidTap(){
        let alert = UIAlertController(title: "Вы действительно хотите удалить счёт?", message: "восстановление данных будет невозможно", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        alert.addAction(cancelAction)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            self.accountsVM.deleteAccount(account: self.oldAccount!)
            self.navigationController?.popToRootViewController(animated: true)
        }
        alert.addAction(deleteAction)
        present(alert, animated: true)
    }
    
    
    @objc private func cancelDidTap(){
        if let oldAccount = oldAccount {
            oldAccount.name = oldAccountValues.name
            oldAccount.amount = oldAccountValues.amount ?? 0.0
            oldAccount.currency = oldAccountValues.currency
            oldAccount.comment = oldAccountValues.comment
        }
        if let newAccount = newAccount {
            accountsVM.deleteAccount(account: newAccount)
        }
        CoreDataService.saveContext()
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction private func chooseCurrencyDidTap(){
        let currenciesVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "\(ChooseCurrencyVC.self)") as? ChooseCurrencyVC
        currenciesVC?.delegate = self
        if let oldAccount = self.oldAccount{
            currenciesVC?.oldAccount = oldAccount
        } else if let newAccount = self.newAccount {
            currenciesVC?.newAccount = newAccount
            currenciesVC?.newAccount?.name = accountNameTextField.text ?? ""
            currenciesVC?.newAccount?.amount = Double(accountBalanceTextField.text ?? "") ?? 0
        }
        currenciesVC?.modalPresentationStyle = .overCurrentContext
        present(currenciesVC ?? .init(), animated: false)
    }
 
    
    @objc private func saveDidTap(){
        guard let name = accountNameTextField.text else {return}
        guard let balance = accountBalanceTextField.text else {return}
        if let oldAccount = self.oldAccount {
            if name != "" && balance != ""{
                oldAccount.name = name
                oldAccount.amount = Double(balance) ?? 0
                oldAccount.dateOfCreating = Date()
                CoreDataService.saveContext()
                navigationController?.popToRootViewController(animated: true)
            }
        }else{
            if let newAccount = self.newAccount {
            CoreDataService.saveContext()
            navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    private func setup(account: Account?){
        if account != nil {
            accountNameTextField.text = account?.name
            accountBalanceTextField.text = "\(account?.amount.cutZero() ?? 0.0.cutZero() )"
            if let currency = account?.currency {
                chooseCurrencyButton.setTitle("\(account?.currencySymbol ?? "") (\(account?.currency ?? ""))", for: .normal)
            }else{
                chooseCurrencyButton.setTitle("Выбрать", for: .normal)
            }
            accountCommentTextView.text = account?.comment
            
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

//MARK: delegate to setup account

extension AddAccountVC : SetupAccountDelegate{
    func setupAccount(account: Account) {
        self.notSavedAccount = account
        setup(account: notSavedAccount)
    }
}
