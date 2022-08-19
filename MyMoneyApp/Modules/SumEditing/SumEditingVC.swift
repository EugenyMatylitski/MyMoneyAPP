//
//  SumEditingVC.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 16.08.22.
//

import Foundation
import UIKit
protocol ReloadSumDelegate  {
    func reloadSum(operation : OperationProtocol)
}

final class SumEditingVC : UIViewController{
    @IBOutlet private weak var currentValue : UILabel!
    @IBOutlet private weak var newValueTextField : UITextField!
    @IBOutlet private weak var viewCenterYConstraint : NSLayoutConstraint!
    @IBOutlet private weak var cancelButton : UIButton!
    @IBOutlet private weak var okButton : UIButton!
    @IBOutlet private weak var backgroundView : UIView!
    var editingVM = EditingViewModel()
    var delegate : ReloadSumDelegate?
    var operation : OperationProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentValue.text = "\(operation?.sum ?? 0.0)"
        newValueTextField.becomeFirstResponder()
        currentValue.text = "\(operation?.sum ?? 0.0)"
        setupView()
        setupButtons()
        self.backgroundView.layer.cornerRadius = 20.0
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAnimation()
        newValueTextField.becomeFirstResponder()
    }
    
    
    
    func showAnimation(){
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.view.backgroundColor = .black.withAlphaComponent(0.2)
            self.viewCenterYConstraint.constant -= self.view.frame.height
            self.view.layoutIfNeeded()
            self.view.layoutSubviews()
        }
        UIView.animate(withDuration: 0.3, delay: 0.1) {
            self.cancelButton.backgroundColor = .white
            self.cancelButton.tintColor = .tintColor
            self.okButton.backgroundColor = .white
            self.okButton.tintColor = .tintColor
        }
    }
    func hideAnimation(){
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) { [self] in
            self.viewCenterYConstraint.constant += view.frame.height
            self.newValueTextField.endEditing(true)
            self.view.layoutIfNeeded()
            self.view.layoutSubviews()
            view.backgroundColor = .clear
            okButton.backgroundColor = .clear
            okButton.tintColor = .clear
            cancelButton.backgroundColor = .clear
            cancelButton.tintColor = .clear
        }completion: { _ in
            self.dismiss(animated: false)
        }
    }
    @IBAction private func gestureDidTap(){
        hideAnimation()
    }
    func setupView(){
        view.backgroundColor = .clear
        self.viewCenterYConstraint.constant += view.frame.height
    }
    func setupButtons(){
        okButton.titleLabel?.font = .systemFont(ofSize: 18)
        okButton.setTitle("ОК", for: .normal)
        okButton.layer.cornerRadius = 20.0
        okButton.titleLabel?.textAlignment = .center
        okButton.backgroundColor = .clear
        okButton.tintColor = .clear
        
        cancelButton.backgroundColor = .clear
        cancelButton.tintColor = .clear
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.layer.cornerRadius = 20
        cancelButton.titleLabel?.textAlignment = .center

        
    }
    @IBAction private func cancelButtonDidTap(){
        hideAnimation()
    }
    @IBAction private func saveButtonDidTap(){
        guard let operation = operation , let sum = Double(newValueTextField.text ?? ""),
        let account = self.operation?.account else {
            return
        }
        let newOperation = editingVM.saveNewSum(operation: operation, account: account, newSum: sum)
        delegate?.reloadSum(operation: newOperation)
        hideAnimation()
         
    }
}


