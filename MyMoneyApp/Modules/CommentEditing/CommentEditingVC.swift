//
//  CommentEditingVC.swift
//  MyMoneyApp
//
//  Created by Eugeny Matylitski on 18.08.22.
//

import Foundation
import UIKit

protocol ReloadCommentDelegate{
    func reloadComment(operation : OperationProtocol)
}


final class CommentEditingVC : UIViewController{
    
    @IBOutlet private weak var textView : UITextView!
    @IBOutlet private weak var okButton : UIButton!
    @IBOutlet private weak var cancelButton : UIButton!
    @IBOutlet private weak var textViewCenterYConstraint : NSLayoutConstraint!
    
    var operation : OperationProtocol!
    var delegate : ReloadCommentDelegate?
    let editingVM = EditingViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        setupView()
        textView.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAnimation()
        textView.becomeFirstResponder()
    }
    
    func setupView(){
        view.backgroundColor = .clear
        self.textViewCenterYConstraint.constant += view.frame.height
        textView.text = operation.comment ?? ""
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
    
// Animation setup block
    func showAnimation(){
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.view.backgroundColor = .black.withAlphaComponent(0.2)
            self.textViewCenterYConstraint.constant
            self.textViewCenterYConstraint.constant -= self.view.frame.height
            self.view.layoutIfNeeded()
            self.view.layoutSubviews()
        }
        UIView.animate(withDuration: 0.3, delay: 0.1) {
            self.cancelButton.backgroundColor = .white
            self.cancelButton.tintColor = .tintColor
        }
    }
    
    func hideAnimation(){
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) { [self] in
            self.textViewCenterYConstraint.constant += view.frame.height
            self.textView.endEditing(true)
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
    
//End of animation block
    
    
    @objc private func cancelButtonDidTap(){
        hideAnimation()
    }
    
    @IBAction private func okDidTap(){
        hideAnimation()
        guard let comment = textView.text else {return}
        let newOperation = editingVM.saveNewComment(operation: operation, comment: comment)
        delegate?.reloadComment(operation: newOperation)
    }
    @IBAction private func missDidTap(){
        hideAnimation()
    }
}


//MARK: TableView delegate

extension CommentEditingVC : UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        if (textView.text != nil) && (textView.text != ""){
            UIView.animate(withDuration: 0.1, delay: 0){ [self] in
                okButton.backgroundColor = .white
                okButton.tintColor = .tintColor
            }
        }else {
            UIView.animate(withDuration: 0.1, delay: 0){ [self] in
                okButton.backgroundColor = .clear
                okButton.tintColor = .clear
            }
        }
    }
}
