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
    var frameLoginButton:CGRect?
    
    private let kErrorTitle = "Error"
    private let kErrorKey = "error"
    private let kOkButtonTitle = "Ok"
    private let kTryAgainMessage = "Tentar Novamente"
    private let kLocationSegue = "showLocationsSegue"
    private let kSignUpLink = "https://auth.udacity.com/sign-up"
    private let kAccount = "account"
    private let kKey = "key"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.text = "rodrigocorcino@gmail.com"
        self.passwordTextField.text = "asdfasdf"
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
    
    @IBAction func signUp(_ sender: Any) {
        let urlString = kSignUpLink
        let url = URL(string: urlString)!
        UIApplication.shared.openURL(url)
    }
    
    func preLogin() {
        DispatchQueue.main.async {        
            self.frameLoginButton = self.loginButton.frame
            self.loginButton.frame = CGRect.zero
            self.view.endEditing(true)
            self.loadingActivity.startAnimating()
        }
    }
    
    @IBAction func login(_ sender: Any) {
        preLogin()
        let service = TaNoMapaService.init()
        
        service.login(email: self.emailTextField.text!, password: self.passwordTextField.text!) { (retorno) in
            
            DispatchQueue.main.async {
                if let msgErro = retorno[self.kErrorKey] as? String{
                    let alert = UIAlertController.init(title: self.kErrorTitle, message: msgErro, preferredStyle: .alert)
                    let okButton = UIAlertAction.init(title: self.kOkButtonTitle, style: .default, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.emailTextField.text = String()
                    self.passwordTextField.text = String()
                    
                    
                    if let account = retorno[self.kAccount] as? NSDictionary {
                        if let key = account[self.kKey] as? String {
                            TaNoMapaService().updateUserWithKey(key)
                        }}
                    
                    self.performSegue(withIdentifier: self.kLocationSegue, sender: self)
                }
                self.posLogin()
            
            }
            
        }
    }
    
    func posLogin() {
        self.loadingActivity.stopAnimating()
        if let frameLoginButton = self.frameLoginButton {
            self.loginButton.frame = frameLoginButton
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
            
            view.frame.origin.y -= 10//getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        print("\(keyboardSize.cgRectValue.height) height")
        return keyboardSize.cgRectValue.height
    }
    
    
    
    
}
