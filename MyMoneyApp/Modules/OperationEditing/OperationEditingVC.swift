//
//  OperationEditingVC.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 15.08.22.
//

import Foundation
import UIKit
import CoreData
final class OperationEditingVC : UIViewController{
    
    @IBOutlet private weak var tableView : UITableView!
    @IBOutlet private weak var deleteButton : UIButton!
    @IBOutlet private weak var topView : UIView!
    var topViewColor : UIColor?
    var operation : OperationProtocol!
    var editingVM = EditingViewModel()
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        setupNavBar()
        setupDeleteButton()
    }
    
    private func setupNavBar(){
        let buttonImage = UIImage(systemName: "chevron.backward")
        let backButton = UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: #selector(backButtonDidTap))
        backButton.tintColor = .white
        navigationItem.setLeftBarButton(backButton, animated: false)
        topView.backgroundColor = self.topViewColor
    }
    
    @objc private func backButtonDidTap(){
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func deleteButtonDidTap(){
        let alert = UIAlertController(title: "Вы действительно хотите \(self.deleteButton.titleLabel?.text?.lowercased() ?? "")? ", message: "восстановить данные будет невозможно", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            self.editingVM.deleteOperation(operation: self.operation)
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    private func setupDeleteButton(){
        switch operation.categoryPicked{
        case .income : deleteButton.setTitle("Удалить доход", for: .normal)
        case .spending : deleteButton.setTitle("Удалить расход", for: .normal)
        }
    }
}


extension OperationEditingVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(EditingCell.self)") as! EditingCell
        if  indexPath.section == 0{
            switch indexPath.row{
            case 0 :
                cell.fieldName = "Счёт" ; cell.currentValue = operation.account?.name
                cell.commentColor = UIColor(r: 106, g: 5, b: 22, alph: 1)
            case 1 : cell.fieldName = "Категория" ; cell.currentValue = operation.categoryName
            case 2 : cell.fieldName = "Сумма" ; cell.currentValue = "\(Int(operation.sum)) \(operation.account?.currencySymbol ?? "")"
                switch operation.categoryPicked{
                case .spending : cell.currentValueColor = .systemRed
                case .income : cell.currentValueColor = .systemGreen
                }
            case 3 :
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "d MMMM yyyy"
                let date = dateFormatter.string(from: operation.date ?? Date())
                cell.fieldName = "Дата" ; cell.currentValue = date
            case 4 :
                cell.fieldName = "Коментарий" ; cell.currentValue = operation.comment ?? ""
                cell.commentColor = .black
            default : break
            }
            return cell
        }
        
        return .init()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return EditingCell.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 1:
            guard let categoriesVC = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "\(CategoryEditingVC.self)") as? CategoryEditingVC
            else {return}
            categoriesVC.delegate = self
            categoriesVC.modalPresentationStyle = .overCurrentContext
            categoriesVC.typeOfOperation = self.operation.categoryPicked
            categoriesVC.operation = self.operation
            tableView.deselectRow(at: indexPath, animated: false)
            present(categoriesVC, animated: false)
        case 0 :
            guard let accountsVC = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "\(AccountsVC.self)") as? AccountsVC
            else {return}
            accountsVC.delegate = self
            self.navigationController?.pushViewController(accountsVC, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        case 2 :
            guard let sumEditingVC = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "\(SumEditingVC.self)") as? SumEditingVC
            else {return}
            sumEditingVC.delegate = self
            sumEditingVC.operation = self.operation
            sumEditingVC.modalPresentationStyle = .overCurrentContext
            present(sumEditingVC, animated: false)
            tableView.deselectRow(at: indexPath, animated: true)
        case 3 :
            guard let dateEditingVC = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "\(DateEditingVC.self)") as? DateEditingVC
            else {return}
            dateEditingVC.delegate = self
            dateEditingVC.operation = self.operation
            dateEditingVC.modalPresentationStyle = .overCurrentContext
            self.present(dateEditingVC, animated: false)
            tableView.deselectRow(at: indexPath, animated: true)
        case 4:guard let commentEditingVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "\(CommentEditingVC.self)") as? CommentEditingVC else {return}
            commentEditingVC.modalPresentationStyle = .overCurrentContext
            commentEditingVC.delegate = self
            commentEditingVC.operation = self.operation
            self.present(commentEditingVC, animated: false)
            tableView.deselectRow(at: indexPath, animated: true)
 
        default : break
        }
    }
}

extension OperationEditingVC : ReloadCategoryDelegate{
    func setOperation(operation: OperationProtocol) {
        self.operation = operation
        tableView.reloadData()
    }
}

extension OperationEditingVC : ReloadAccountDelegate {
    func saveAccount(account: Account) {
        guard let oldAccount = self.operation.account else {return}
        let operation = self.editingVM.saveAccount(oldAccount : oldAccount , newAccount: account, operation: operation)
        self.operation = operation
        tableView.reloadData()
    }
}

extension OperationEditingVC : ReloadSumDelegate{
    func reloadSum(operation: OperationProtocol) {
        self.operation = operation
        tableView.reloadData()
    }
}
extension OperationEditingVC : ReloadDateDelegate{
    func reloadDate(operation: OperationProtocol) {
        self.operation = operation
        tableView.reloadData()
    }
}
extension OperationEditingVC : ReloadCommentDelegate{
    func reloadComment(operation: OperationProtocol) {
        self.operation = operation
        tableView.reloadData()
    }
    
    
}
