//
//  ChooseCurrencyVC.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 12.08.22.
//

import Foundation
import UIKit
protocol SetupAccountDelegate {
    func setupAccount(account : Account)
}

final class ChooseCurrencyVC : UIViewController{
    @IBOutlet private weak var tableView : UITableView!
    @IBOutlet private weak var backgroundView : UIView!
    let currencies : [Currency] = [(name : "Доллар США", symbol: "usd"),
                                   (name: "Евро", symbol: "eur"),
                                   (name: "Белорусский рубль", symbol: "byn")]
    var account : Account?
    var delegate : SetupAccountDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        setupNavBar()
        self.backgroundView.layer.cornerRadius = 20.0
        hideElements()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAnimation()
    }
    
    func hideElements(){
        tableView.backgroundColor = .clear
        self.view.backgroundColor = .clear
    }
    
    func showAnimation(){
        UIView.animate(withDuration: 0.2, delay: 0) {
            self.view.backgroundColor = .black.withAlphaComponent(0.2)
            self.tableView.backgroundColor = .white
        }
    }
    private func setupNavBar(){
        let buttonImage = UIImage(systemName: "chevron.backward")
        let backButton = UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: #selector(backButtonDidTap))
        backButton.tintColor = .white
        navigationItem.setLeftBarButton(backButton, animated: false)

    }
    
    @objc private func backButtonDidTap(){
        navigationController?.popViewController(animated: true)
    }
    @IBAction private func tapGestureDidTap(){
        dismiss(animated: false)
    }
}

extension ChooseCurrencyVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(CurrencyCell.self)") as? CurrencyCell
        cell?.currency = currencies[indexPath.row]
        cell?.hideElements()
        cell?.showElements()
        if cell?.currency?.symbol == self.account?.currency ?? ""{
            cell?.accessoryType = .checkmark
        }
        return cell ?? .init()
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CurrencyCell.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        self.account?.currency = currencies[indexPath.row].symbol
        CoreDataService.saveContext()
        delegate?.setupAccount(account: account!)
        dismiss(animated: false)
    }
}
