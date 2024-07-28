//
//  ViewController.swift
//  Cut It Short
//
//  Created by Hakan Türkmen on 28.07.2024.
//

import UIKit
import GoogleGenerativeAI
import SnapKit

class AskVC: UIViewController {
    
    var appNameLabel = UILabel()
    var promptTextField = UITextView()
    var responseLabel = UITextView()
    var isNewQuestion = false
    
    var loadingIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setUI()
        configureUI()
        
        
    }
    
    func configureUI()
    {
        promptTextField.autocorrectionType = .no
        promptTextField.delegate = self
        promptTextField.layer.borderWidth = 1
        promptTextField.layer.borderColor = UIColor.lightGray.cgColor
        promptTextField.layer.cornerRadius = 10
        promptTextField.font = .systemFont(ofSize: 20, weight: .semibold)
        appNameLabel.text = "Cut It Short"
        
        appNameLabel.textAlignment = .center
        appNameLabel.font = .boldSystemFont(ofSize: 25)
        
        responseLabel.isEditable = false
        responseLabel.isSelectable = true
        responseLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        responseLabel.addSubview(loadingIndicator)
        loadingIndicator.style = .large
        loadingIndicator.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
    
    func setUI()
    {
        view.addSubview(promptTextField)
        view.addSubview(responseLabel)
        view.addSubview(appNameLabel)
        
        appNameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        promptTextField.snp.makeConstraints { make in
            make.width.equalTo(view.frame.width / 1.3)
            make.height.equalTo(100)
            make.center.equalToSuperview()
        }
        
        responseLabel.snp.makeConstraints { make in
            make.top.equalTo(promptTextField.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
    private func movePromptToAppName() {
        promptTextField.snp.remakeConstraints { make in
            make.top.equalTo(appNameLabel.snp.bottom).offset(10)
            make.width.equalTo(view.frame.width / 1.3)
            make.height.equalTo(100)
            make.centerX.equalToSuperview()
        }
        responseLabel.snp.remakeConstraints { make in
            make.top.equalTo(promptTextField.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        // Layout'u güncelleme
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func movePromptToOldPlace() {
        promptTextField.snp.remakeConstraints { make in
            make.width.equalTo(view.frame.width / 1.3)
            make.height.equalTo(100)
            make.center.equalToSuperview()
        }
        
        responseLabel.snp.remakeConstraints { make in
            make.top.equalTo(promptTextField.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        // Layout'u güncelleme
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    
}
extension AskVC :  UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if isNewQuestion
        {
            promptTextField.text = ""
            responseLabel.text = ""
            movePromptToOldPlace()
            
            isNewQuestion = false
        }
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            // Metni işleme
            Task {
                loadingIndicator.startAnimating()
                let response = try await NetworkManager.shared.getResponse(userText: promptTextField.text)
                DispatchQueue.main.async {
                    self.loadingIndicator.stopAnimating()
                    self.responseLabel.text = response
                    self.isNewQuestion = true
                }
            }
            textView.resignFirstResponder()
            movePromptToAppName()
            return false
        }
        return true
    }
}
