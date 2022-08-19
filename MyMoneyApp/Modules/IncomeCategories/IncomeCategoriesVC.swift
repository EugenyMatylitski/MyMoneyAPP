//
//  IncomeCategoriesVC.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 11.08.22.
//

import Foundation
import UIKit

final class IncomeCategoriesVC: UIViewController{
    @IBOutlet private weak var categoriesCollectionView : UICollectionView!
    @IBOutlet private weak var historyButton : UIButton!
    @IBOutlet private weak var topView : UIView!
    let incomeCategoriesVM = IncomeCategoriesViewModel()
    private var categories : [IncomeCategories]!{
        didSet{
            categoriesCollectionView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        historyButton.layer.cornerRadius = 15
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.categories = incomeCategoriesVM.loadCategories()
        loadCategories()
    }
    
    func loadCategories(){
        guard let categories = incomeCategoriesVM.loadCategories() else {return}
        self.categories = categories
    }
    
    @IBAction private func historyButtonDidTap(){
       guard let operationsVC = UIStoryboard(name: "Main", bundle: nil)
        .instantiateViewController(withIdentifier: "\(OperationsVC.self)") as? OperationsVC else {return}
        operationsVC.typeOfOperation = .income
        operationsVC.topViewColor = self.topView.backgroundColor
        operationsVC.modalPresentationStyle = .overCurrentContext
        navigationController?.pushViewController(operationsVC, animated: true)
    }
    @IBAction private func longPress(){
//        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(CalculatorVC.self)")
//        present(nextVC, animated: true)
    }
}

extension IncomeCategoriesVC : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let incomes = categories[indexPath.row].allIncomes
        let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "\(CategoryCell.self)", for: indexPath) as? CategoryCell
        cell?.setupIncomes(category: categories[indexPath.row], incomes: incomes)
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

extension IncomeCategoriesVC : ReloadDataDelegate{
    func reloadData() {
        loadCategories()
    }
    
    
}
