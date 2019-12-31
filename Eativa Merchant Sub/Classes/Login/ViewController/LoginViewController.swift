//
//  LoginViewController.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 30/11/19.
//  Copyright © 2019 Frederic Orlando. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var orangeImageView: UIImageView!
    @IBOutlet weak var orangeHalfScreenConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        checkLoginStatus()
        
        setupTextField()
        
        setupButton()
        
        setupConstraint()
        
        setupObserver()
    }

    func setupConstraint() {
        let interfaceIdiom = UIDevice.current.userInterfaceIdiom
        
        if interfaceIdiom == .phone {
            let screenWidth = UIScreen.main.bounds.width
            orangeHalfScreenConstraint.isActive = false
            orangeImageView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        }
    }
    
    func setupTextField() {
        emailTxt.delegate = self
        passTxt.delegate = self
    }
    
    func setupButton() {
        loginButton.backgroundColor = .appGreen
        loginButton.setTitleColor(.systemOrange, for: .normal)
        
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        loginButton.layer.cornerRadius = 8
    }
    
    func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification : Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            var yOffset : Int
            if keyboardSize.height > 400 {
                yOffset = 200
            }
            else {
                yOffset = 100
            }
            
            scrollView.setContentOffset(CGPoint(x: 0, y: yOffset), animated: true)
            
            UIView.animate(withDuration: 0.5) {
                self.logoImageView.alpha = 0
            }
        }
    }
    
    @objc func keyboardWillHide(notification : Notification) {
        scrollView.setContentOffset(.zero, animated: true)
        
        UIView.animate(withDuration: 0.5) {
            self.logoImageView.alpha = 1
        }
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        login()
    }
    
    func validate(email : String?, password : String?) -> Bool {
        let testEmail = "fred"
        let testPassword = "17ecff8e89aec65ae5abf28c797e2dfcea9afeebb23983b24c245033f7cc4096"
        
        if email != nil && password != nil {
            if email! == testEmail && password!.encrypted == testPassword {
                return true
            }
        }
        
        return false
    }
    
    func login() {
        guard let email = emailTxt.text, let password = passTxt.text else {
            return
        }
        
        let params = [
            "email": email,
            "password": password.encrypted
        ]
        
        APIService.signin(parameter: params) { (isVerified, error) in
            if let error = error {
                return
            }
            
            if isVerified! {
                DispatchQueue.main.async {
                    
                    if (CurrentUser.id != "") {
                        PusherChannels.subscribePushChannel(channel: CurrentUser.id)
                        PusherBeams.registerDeviceInterest(pushInterest: CurrentUser.id)
                    }
                    
                    self.navigateToMain()
                }
               
            }
        }
    }
    
    func checkLoginStatus() {
        if Defaults.getToken() != "" {
            CurrentUser.loadFromDefaults()
            
            PusherChannels.subscribePushChannel(channel: CurrentUser.id)
            
            navigateToMain()
        }
    }
    
    func navigateToMain() {
        APIService.getDetail(.merchants, id: CurrentUser.id) { (merchant, error) in
            if error != nil {
                return
            }
            
            CurrentUser.merchant = merchant as! Merchant
            
            DispatchQueue.main.async {
                let vc = UIStoryboard.getController(from: "Main", withIdentifier: "splitView")
                UIApplication.changeRoot(to: vc)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = view.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            login()
        }

        return true
    }
}
