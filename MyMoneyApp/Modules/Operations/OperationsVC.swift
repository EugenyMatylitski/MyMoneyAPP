//
//  OperationsVC.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 26.07.22.
//

import Foundation
import UIKit
import DropDown

final class OperationsVC : UIViewController{
    
    
    @IBOutlet private weak var tableView : UITableView!
    @IBOutlet private weak var topView : UIView!
    var topViewColor : UIColor?
    let menu = DropDown()
    var datePicked : DatePicked?
    var oldDate = Date()
    var oldIndex : Index?
    var oldTitle : String?
    
    var typeOfOperation : CategoryPicked?
    let operationsViewModel = OperationsViewModel()
    var operations : [OperationProtocol] = []{
        didSet{
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setupNavBar()
        setupDropDown()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadOperationsFiltered()
    }
    
    func loadOperationsFiltered(){
        switch navigationItem.rightBarButtonItem?.title {
        case DatePicked.allTime.rawValue :
            loadOperations()
        case DatePicked.today.rawValue :
            switch self.typeOfOperation {
            case .income:
                        self.operations = self.operationsViewModel.loadIncomeDateFilteredOperations(date: Date(), number: 1)
            case .spending:
                        self.operations = self.operationsViewModel.loadSpendingDateFilteredOperations(date: Date(), number: 1)
            case .none : break
            }
        case DatePicked.week.rawValue :
            switch self.typeOfOperation {
            case .income:
                        self.operations = self.operationsViewModel.loadIncomeDateFilteredOperations(date: Date(), number: 2)
                
            case .spending:
                        self.operations = self.operationsViewModel.loadSpendingDateFilteredOperations(date: Date(), number: 2)
            case .none : break
            }
        case DatePicked.month.rawValue:
            switch self.typeOfOperation {
            case .income:
                        self.operations = self.operationsViewModel.loadIncomeDateFilteredOperations(date: Date(), number: 3)
            case .spending:
                        self.operations = self.operationsViewModel.loadSpendingDateFilteredOperations(date: Date(), number: 3)
            case .none : break
            }
        default : break
        }
    }
    

    
    func loadOperations(){
        switch self.typeOfOperation {
        case .income:
            operations = operationsViewModel.loadIncomeOperations()
        case .spending:
            operations = operationsViewModel.loadSpendingOperations()
        case .none : break
        }
    }
    
    func loadDateFilteredOperations(index : Index, date : Date){
        switch self.typeOfOperation {
        case .income:
            operations = operationsViewModel.loadIncomeDateFilteredOperations(date: date, number: index)
        case .spending:
            operations = operationsViewModel.loadSpendingDateFilteredOperations(date: date, number: index)
        case .none : break
        }
        
    }
    
    private func setupNavBar(){
        let buttonImage = UIImage(systemName: "chevron.backward")
        let backButton = UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: #selector(backButtonDidTap))
        backButton.tintColor = .white
        self.navigationItem.setLeftBarButton(backButton, animated: false)
        let rightButton = UIBarButtonItem(title: "За всё время", style: .plain, target: self, action: #selector(didTap))
        rightButton.tintColor = .white
        self.navigationItem.setRightBarButton(rightButton, animated: false)
        self.topView.backgroundColor = self.topViewColor
    }
    
    
    private func setupDropDown(){
        menu.anchorView = navigationItem.rightBarButtonItem
        menu.dataSource = [DatePicked.allTime.rawValue,
                           DatePicked.today.rawValue,
                           DatePicked.week.rawValue,
                           DatePicked.month.rawValue,
                           DatePicked.customDate.rawValue]
            menu.selectionAction =  { index, title in
                if index == 4{
                    self.navigationItem.rightBarButtonItem?.title = "\(self.oldTitle ?? DatePicked.allTime.rawValue)"
                    self.loadDateFilteredOperations(index: self.oldIndex ?? 0, date: self.oldDate)
                    let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(DateChoosingVC.self)")
                    as? DateChoosingVC
                    nextVC?.delegate = self
                    nextVC?.modalPresentationStyle = .overCurrentContext
                    self.present(nextVC!, animated: false)
                }else {
                    self.oldTitle = title
                    self.oldIndex = index
                
                self.navigationItem.rightBarButtonItem?.title = "\(title)"
                self.loadDateFilteredOperations(index: index, date: Date())
                }
            }
        
        menu.selectionBackgroundColor = .lightGray
    }
    
    @objc func didTap(){
        for (index, value) in menu.dataSource.enumerated(){
            if value == self.navigationItem.rightBarButtonItem?.title{
                menu.selectRow(index)
            }
        }
        menu.show()
    }
    
    @objc private func backButtonDidTap(){
        navigationController?.popViewController(animated: true)
    }
}


extension OperationsVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return operations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(OperationCell.self)") as! OperationCell
        switch self.typeOfOperation{
        case .spending : cell.spending = operations[indexPath.row] as? Spending
        case .income   : cell.income = operations[indexPath.row] as? Income
        case .none : break
        }
        return cell 
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let editingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(OperationEditingVC.self)") as? OperationEditingVC else {return}
        editingVC.operation = operations[indexPath.row]
        editingVC.topViewColor = self.topViewColor
        navigationController?.pushViewController(editingVC, animated: true)
    }
    
}

extension OperationsVC : ChosenDateDelegate{
    func setChosenDate(date : Date){
        self.loadDateFilteredOperations(index: 1, date: date)
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        self.navigationItem.rightBarButtonItem?.title = formatter.string(from: date)
        self.oldTitle = self.navigationItem.rightBarButtonItem?.title
        self.oldDate = date
        self.oldIndex = 1
    }
}
