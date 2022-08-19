//
//  DateChoosingVC.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 17.08.22.
//

import Foundation
import UIKit
protocol ChosenDateDelegate {
    func setChosenDate(date : Date)
}


final class DateChoosingVC : UIViewController{
    @IBOutlet private weak var datePicker : UIDatePicker!
    @IBOutlet private weak var okButton : UIButton!
    @IBOutlet private weak var cancelButton : UIButton!
    
    
    var delegate : ChosenDateDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupButtons()
    }
    
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
        UIView.animate(withDuration: 0.2, delay: 0) { [self] in
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
        delegate?.setChosenDate(date: datePicker.date)
       hideAnimation()
    }
    @IBAction func missDidTap(){
        hideAnimation()
    }
}


