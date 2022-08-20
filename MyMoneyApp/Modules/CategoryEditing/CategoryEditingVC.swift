//
//  CategoryEditingVC.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 16.08.22.
//

import Foundation
import UIKit

//MARK: delegate to update category of selected operation

protocol ReloadCategoryDelegate  {
    func setOperation(operation : OperationProtocol)
}

final class CategoryEditingVC : UIViewController{
    @IBOutlet private weak var categoriesCollectionView : UICollectionView!
    
    var categories : [CategoryProtocol] = []
    var typeOfOperation : CategoryPicked!
    var operation : OperationProtocol!
    var delegate : ReloadCategoryDelegate?
    let editingVM = EditingViewModel()
    var indexPath : IndexPath?{
        didSet{
            let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "\(CategoryCell.self)", for: indexPath!) as? CategoryCell
            cell?.showElements()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCategories()
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        self.view.backgroundColor = .black.withAlphaComponent(0.2)
        hideElements()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAnimation()
    }
   
    func hideElements(){
        categoriesCollectionView.backgroundColor = .clear
    }
    
    func showAnimation(){
        UIView.animate(withDuration: 0.2, delay: 0) {
            self.categoriesCollectionView.backgroundColor = .white
        }
    }
    
    func setupCategories (){
        switch typeOfOperation {
        case .income:
            categories = editingVM.loadIncomeCategories() ?? []
        case .spending:
            categories = editingVM.loadSpendingCategories() ?? []
        case .none :
            break
        }
    }
    
    @IBAction private func tapGesture(){
        dismiss(animated: false)
    }
}


extension CategoryEditingVC : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "\(CategoryCell.self)", for: indexPath) as? CategoryCell
        cell?.operation = self.operation
        cell?.hideElements()
        cell?.showElements()
        switch typeOfOperation {
        case .income :
            cell?.setupIncomesForEdit(category: categories[indexPath.row] as! IncomeCategories)
        case .spending :
            cell?.setupSpendingsForEdit(category: categories[indexPath.row] as! SpendingCategories)
        case .none : break
        }
        
        return cell ?? .init()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width / 4.0
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newOperation = editingVM.updateCategory(category: categories[indexPath.row], operation: self.operation)
        delegate?.setOperation(operation:newOperation)
        dismiss(animated: false)
    }
}
