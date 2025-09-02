//
//  ViewController.swift
//  NotificationHW
//
//  Created by Артём Сноегин on 02.09.2025.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    let textLabel = UILabel()
    let textField = UITextField()
    let saveButton = UIButton(configuration: .filled())
    
    var animatedConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        hideKeyboardOnTap()
        subscribeNotification()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        textLabel.textAlignment = .center
        textLabel.font = .boldSystemFont(ofSize: 30)
        
        textField.placeholder = "Enter some text"
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 20)
        textField.delegate = self
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.tintColor = .systemGreen
        saveButton.addTarget(self, action: #selector(saveText), for: .touchUpInside)
        saveButton.isEnabled = false
        
        [textLabel, textField, saveButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
            
            $0.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
            $0.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        }
        
        animatedConstraint = textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        
        if let textLabelCenterYConstraint = animatedConstraint {
            textLabelCenterYConstraint.isActive = true
        }
        
        NSLayoutConstraint.activate([
            textLabel.heightAnchor.constraint(equalToConstant: 35),
            
            textField.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 16),
            textField.heightAnchor.constraint(equalToConstant: 40),
            
            saveButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if text.isEmpty {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
    
    @objc private func saveText() {
        let transition = CATransition()
        transition.type = .push
        transition.duration = 0.5
        textLabel.layer.add(transition, forKey: "transition")
        
        textLabel.text = textField.text
        textField.text = ""
        textField.endEditing(true)
    }
    
    private func hideKeyboardOnTap() {
        let hideKeyboardTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnEmptyScreen))
        view.addGestureRecognizer(hideKeyboardTapGesture)
    }
    
    @objc private func didTapOnEmptyScreen() {
        textField.endEditing(true)
    }
    
    private func subscribeNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        UIView.animate(withDuration: 0.5) {
            self.animatedConstraint?.constant = -60
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.5) {
            self.animatedConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    private func unsubscribeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        unsubscribeNotification()
    }
    
}
