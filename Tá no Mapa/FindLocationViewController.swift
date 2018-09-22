//
//  FindLocationViewController.swift
//  Tá no Mapa
//
//  Created by Mac mini on 11/09/2018.
//  Copyright © 2018 Rodrigo. All rights reserved.
//

import UIKit
import MapKit

class FindLocationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    
    private let kOnTheMap = "On the map"
    private let kRequiredLocation = "Required location"
    private let kLocationNotFound = "Location not found"
    private let kOKButtonTitle = "Ok"
    var frameFindnButton:CGRect?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.urlTextField.delegate = self
        self.locationTextField.delegate = self
        subscribeToKeyboardNotifications()
    }
    
    // MARK: - IBAction methods
    @IBAction func findLocation(sender: UIButton) {
        
        guard let locationString = locationTextField.text, !(locationTextField.text?.isEmpty)! else {
            let alert = UIAlertController.init(title: kOnTheMap, message: kRequiredLocation, preferredStyle: .alert)
            let okButton = UIAlertAction.init(title: kOKButtonTitle, style: .default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
            return
        }
        goToLocation(locationString)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - FindLocationViewController methods
    func preLocation() {
        DispatchQueue.main.async {
            self.frameFindnButton = self.findButton.frame
            self.findButton.frame = CGRect.zero
            self.view.endEditing(true)
            self.loadingActivity.startAnimating()
        }
    }

    func posLocation() {
        self.loadingActivity.stopAnimating()
        if let frameFindButton = self.frameFindnButton {
            self.findButton.frame = frameFindButton
        }
    }
    
    fileprivate func goToLocation(_ locationString: String) {
        preLocation()
        CLGeocoder().geocodeAddressString(locationString) { (placemark, error) in
            self.posLocation()
            guard error == nil else {
                let alert = UIAlertController.init(title: self.kOnTheMap, message: self.kLocationNotFound, preferredStyle: .alert)
                let okButton = UIAlertAction.init(title: self.kOKButtonTitle, style: .default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            self.performSegue(withIdentifier: "segueShowNewLocation", sender: placemark!.first?.location?.coordinate)
        }
    }
   
    // MARK: - Navigation method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let locationViewController = segue.destination as? ShowNewLocationViewController {
            if let cordinate = sender as? CLLocationCoordinate2D {
                locationViewController.coordinate = cordinate
                
                guard let locationString = locationTextField.text, !(locationTextField.text?.isEmpty)! else {
                    return
                }
                guard let urlString = urlTextField.text, !(urlTextField.text?.isEmpty)! else {
                    return
                }
                locationViewController.locationString = locationString
                locationViewController.urlString = urlString
            }
        }
    }
    
}

extension FindLocationViewController {
    
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
            let keyboardSize2 = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
            view.frame.origin.y -= keyboardSize2.height - 50
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

