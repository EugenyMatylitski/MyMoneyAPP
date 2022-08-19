//
//  ViewController.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 18.07.22.
//

import UIKit
import CoreData

class CategoriesVC: UIViewController{
    @IBOutlet private weak var categoriesCollectionView : UICollectionView!
    @IBOutlet private weak var historyButton : UIButton!
    @IBOutlet private weak var topView : UIView!
    var fetchedResultsController : NSFetchedResultsController<SpendingCategories>?
    var categories : [SpendingCategories] = []{
        didSet{
            categoriesCollectionView.reloadData()
        }
    }
    
    let categoriesVM = CategoriesVCModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        loadCategories()
        historyButton.layer.cornerRadius = 15
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCategories()
    }
    
    func loadCategories(){
        guard let categories = categoriesVM.loadCategories() else {return}
        self.categories = categories
    }
    
    @IBAction private func historyButtonDidTap(){
       guard let operationsVC = UIStoryboard(name: "Main", bundle: nil)
        .instantiateViewController(withIdentifier: "\(OperationsVC.self)") as? OperationsVC else {return}
        operationsVC.typeOfOperation = .spending
        operationsVC.topViewColor = self.topView.backgroundColor
        operationsVC.modalPresentationStyle = .overCurrentContext
        navigationController?.pushViewController(operationsVC, animated: true)
    }
}


extension CategoriesVC : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let spendings = categories[indexPath.row].allSpendings
        let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "\(CategoryCell.self)", for: indexPath) as? CategoryCell
        cell?.setupSpending(category: categories[indexPath.row], spendings: spendings)
        return cell ?? .init()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width / 3.0
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let calcVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "\(CalculatorVC.self)") as? CalculatorVC else {return}
        calcVC.delegate = self
        calcVC.selectedCategory = categories[indexPath.row]
        calcVC.modalPresentationStyle = .overCurrentContext
        present(calcVC, animated: true)
        
    }
}

extension CategoriesVC : ReloadDataDelegate{
    func reloadData() {
        loadCategories()
    }
}


