//
//  LoginViewController.swift
//  Tá no Mapa
//
//  Created by Rodrigo on 02/09/2018.
//  Copyright © 2018 Rodrigo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    
    private let kErrorTitle = "Error"
    private let kErrorKey = "error"
    private let kOkButtonTitle = "Ok"
    private let kTryAgainMessage = "Tentar Novamente"
    private let kLocationSegue = "showLocationsSegue"
    private let kSignUpLink = "https://auth.udacity.com/sign-up"
    private let kAccount = "account"
    private let kKey = "key"
    private let kEmptyEmailorPassword = "Empty Email or Password"
    private let kInvalidEmailorPassword = "Invalid Email"
    
    
    // MARK: - UIViewController override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func setupLayout() {
        self.loginButton.layer.cornerRadius = 5
        let attrStr = NSMutableAttributedString.init(string: signUpButton.title(for: .normal)!)
        attrStr.addAttribute(.foregroundColor, value: UIColor.blue, range: NSMakeRange(23, 7))
        signUpButton.setAttributedTitle(attrStr, for: .normal)
    }
    
    // MARK: IBActions methods
    @IBAction func signUp(_ sender: Any) {
        let urlString = kSignUpLink
        let url = URL(string: urlString)!
        UIApplication.shared.openURL(url)
    }
    
    func validateTexts() -> Bool {
        var errorMsg:String?
        
        if (self.passwordTextField.text?.isEmpty)!  ||
            (self.emailTextField.text?.isEmpty)! {
            errorMsg = kEmptyEmailorPassword
        } else if !(self.emailTextField.text?.isValidEmail())! {
            errorMsg = kInvalidEmailorPassword
        }
        
        if (errorMsg != nil) {
            let alert = UIAlertController.init(title: self.kErrorTitle, message: errorMsg, preferredStyle: .alert)
            let okButton = UIAlertAction.init(title: self.kOkButtonTitle, style: .default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    @IBAction func login(_ sender: Any) {
        if !validateTexts() {
            return
        }
        DispatchQueue.main.async {
            self.loginButton.isHidden = true
            self.view.endEditing(true)
            self.loadingActivity.startAnimating()
        }
        
        let service = TaNoMapaService.init()
        
        self.view.endEditing(true)
        service.login(email: self.emailTextField.text!, password: self.passwordTextField.text!) { (retorno, errorMessage) in
             self.posLogin()
            if errorMessage != nil {
                let alert = UIAlertController.init(title: self.kErrorTitle, message: errorMessage, preferredStyle: .alert)
                let okButton = UIAlertAction.init(title: self.kOkButtonTitle, style: .default, handler: nil)
                alert.addAction(okButton)
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
            
            if let msgErro = retorno![self.kErrorKey] as? String{
                let alert = UIAlertController.init(title: self.kErrorTitle, message: msgErro, preferredStyle: .alert)
                let okButton = UIAlertAction.init(title: self.kOkButtonTitle, style: .default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            } else {
                self.emailTextField.text = String()
                self.passwordTextField.text = String()
                
                if let account = retorno![self.kAccount] as? NSDictionary {
                    if let key = account[self.kKey] as? String {
                        TaNoMapaService().updateUserWithKey(key)
                    }}
                
                self.performSegue(withIdentifier: self.kLocationSegue, sender: self)
            }
           
            
        }
    }
    
    func posLogin() {
        DispatchQueue.main.async {
            self.loadingActivity.stopAnimating()
            self.loginButton.isHidden = false
        }
    }
    
}

extension LoginViewController {
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    // MARK: - NotificationCenter methods
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - keyboard methods
    @objc func keyboardWillShow(_ notification:Notification) {
        if (view.frame.origin.y == 0) {
            view.frame.origin.y -= 10
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.cgRectValue.height
    }
    
}

extension String {
    func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
