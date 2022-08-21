//
//  AccountsVC.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 21.07.22.
//

import Foundation
import UIKit
import CoreData

protocol ReloadAccountDelegate {
    func saveAccount(account : Account)
}

final class AccountsVC : UIViewController{
    @IBOutlet private var bynLabel : UILabel!
    @IBOutlet private var usdLabel : UILabel!
    @IBOutlet private var eurLabel : UILabel!
    @IBOutlet private var navbar : UINavigationItem!
    @IBOutlet private weak var topView : UIView!
    @IBOutlet private var accountsTableView : UITableView!{
        didSet{
            accountsTableView.dataSource = self
            accountsTableView.delegate = self
        }
    }
    
    var delegate : ReloadAccountDelegate?
    var fetchedResultsController : NSFetchedResultsController<Account>?
    let accountsVM = AccountsViewModel()
    var accounts : [Account] = []{
        didSet{
            accountsTableView.reloadData()
            var bynSum : Double = 0
            var usdSum : Double = 0
            var eurSum : Double = 0
            accounts.forEach { account in
                if account.currency == "byn"{
                    bynSum += account.amount
                }else if account.currency == "eur" {
                    eurSum += account.amount
                }else {
                    usdSum += account.amount
                }
            }
            bynLabel.text = "BYN \(bynSum)"
            eurLabel.text = "\u{20AC} \(eurSum)"
            usdLabel.text = "\u{0024} \(usdSum)"
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultsController?.delegate = self
        setupNavBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAccounts()
    }
    
    private func setupNavBar(){
        if delegate == nil{
        navbar.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAccountButtonDidTap))
        navbar.rightBarButtonItem?.tintColor = .white
        } else{
            let buttonImage = UIImage(systemName: "chevron.backward")
            let backButton = UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: #selector(backButtonDidTap))
            backButton.tintColor = .white
            self.navigationItem.setLeftBarButton(backButton, animated: false)
        }
    }
    @objc private func backButtonDidTap(){
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc private func addAccountButtonDidTap(){
        guard let nextVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "\(AddAccountVC.self)") as? AddAccountVC
        else {return}
        nextVC.newAccount = Account(context: CoreDataService.mainContext)
        nextVC.topViewColor = self.topView.backgroundColor
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
   
    
    private func loadAccounts(){
        let request = Account.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Account.amount), ascending: false)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataService.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        try? fetchedResultsController?.performFetch()
        self.accounts = fetchedResultsController?.fetchedObjects ?? []
    }

}

extension AccountsVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let accountCell = accountsTableView.dequeueReusableCell(withIdentifier: "\(AccountCell.self)", for: indexPath) as? AccountCell
        accountCell?.setup(account: accounts[indexPath.row])
        return accountCell ?? .init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if delegate == nil{
        accountsTableView.deselectRow(at: indexPath, animated: true)
        guard let nextVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "\(AddAccountVC.self)") as? AddAccountVC else {return}
            nextVC.oldAccount = accounts[indexPath.row]
            navigationController?.pushViewController(nextVC, animated: true)
            nextVC.topViewColor = self.topView.backgroundColor
        } else {
            delegate?.saveAccount(account: accounts[indexPath.row])
            navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AccountCell.rowHeight
    }
}

extension AccountsVC : NSFetchedResultsControllerDelegate{
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        loadAccounts()
    }
}
