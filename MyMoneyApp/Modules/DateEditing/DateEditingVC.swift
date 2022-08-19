//
//  DateEditingVC.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 16.08.22.
//

import Foundation
import UIKit

protocol ReloadDateDelegate {
    func reloadDate (operation : OperationProtocol)
}

//final class DateEditingVC : UIViewController{
//    @IBOutlet private weak var datePicker : UIDatePicker!
//    var operation : OperationProtocol!
//    var editingVM = EditingViewModel()
//    var delegate : ReloadDateDelegate?
//    override func viewDidLoad() {
//        datePicker.date = operation.date ?? Date()
//        setupNavBar()
//    }
//
//    private func setupNavBar(){
//        let buttonImage = UIImage(systemName: "chevron.backward")
//        let backButton = UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: #selector(backButtonDidTap))
//        backButton.tintColor = .white
//        navigationItem.setLeftBarButton(backButton, animated: false)
//        let saveButton = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(saveButtonDidTap))
//        saveButton.tintColor = .white
//        navigationItem.setRightBarButton(saveButton, animated: false)
//    }
//    @objc private func backButtonDidTap(){
//        navigationController?.popViewController(animated: true)
//    }
//    @objc private func saveButtonDidTap(){
//        let newOperation = editingVM.saveNewDate(operation: self.operation, date: datePicker.date)
//        delegate?.reloadDate(operation: newOperation)
//        navigationController?.popViewController(animated: true)
//    }
//}

final class DateEditingVC : UIViewController{
    @IBOutlet private weak var datePicker : UIDatePicker!
    @IBOutlet private weak var okButton : UIButton!
    @IBOutlet private weak var cancelButton : UIButton!
    
    var operation : OperationProtocol!
    var editingVM = EditingViewModel()
    override func viewDidLoad() {
        datePicker.date = operation.date ?? Date()
        setupView()
        setupButtons()
    }
    
    var delegate : ReloadDateDelegate?
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showAnimation()
    }
    
    func showAnimation(){
        UIView.animate(withDuration: 0.2, delay: 0) {
            self.view.backgroundColor = .black.withAlphaComponent(0.2)
            self.datePicker.backgroundColor = .white
            self.datePicker.alpha = 1.0
            self.datePicker.tintColor = .tintColor
            self.cancelButton.backgroundColor = .white
            self.cancelButton.tintColor = .tintColor
        }
    }
    
    func setupView(){
        datePicker.alpha = 0.0
        datePicker.backgroundColor = .clear
        datePicker.tintColor = .clear
        view.backgroundColor = .clear
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
        cancelButton.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
        
        
    }
    @IBAction private func animate(){
        UIView.animate(withDuration: 0.1, delay: 0){ [self] in
            okButton.backgroundColor = .white
            okButton.tintColor = .tintColor
        }
    }
 
    func hideAnimation(){
        UIView.animate(withDuration: 0.1, delay: 0) { [self] in
            datePicker.backgroundColor = .clear
            datePicker.alpha = 0.0
            datePicker.tintColor = .clear
            view.backgroundColor = .clear
            okButton.backgroundColor = .clear
            okButton.tintColor = .clear
            cancelButton.backgroundColor = .clear
            cancelButton.tintColor = .clear
        }completion: { _ in
            self.dismiss(animated: false)
        }
    }
    
    @objc private func cancelButtonDidTap(){
       hideAnimation()
    }
    
    @IBAction private func okDidTap(){
        let newOperation = editingVM.saveNewDate(operation: self.operation, date: datePicker.date)
        delegate?.reloadDate(operation: newOperation)
        hideAnimation()
    }
    @IBAction private func tapGesture(){
        hideAnimation()
    }
}
