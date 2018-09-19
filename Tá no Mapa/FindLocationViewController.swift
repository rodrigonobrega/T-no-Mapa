//
//  FindLocationViewController.swift
//  Tá no Mapa
//
//  Created by Mac mini on 11/09/2018.
//  Copyright © 2018 Rodrigo. All rights reserved.
//

import UIKit
import MapKit

class FindLocationViewController: UIViewController {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    
    
    @IBAction func findLocation(sender: UIButton) {
        
        guard let locationString = locationTextField.text, !(locationTextField.text?.isEmpty)! else {
            let alert = UIAlertController.init(title: "Tá no mapa", message: "Informe o local", preferredStyle: .alert)
            let okButton = UIAlertAction.init(title: "ok", style: .default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
            return
        }
        goToLocation(locationString)
    }
    
    var frameFindnButton:CGRect?
    
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
        if let frameFindnButton = self.frameFindnButton {
            self.findButton.frame = frameFindnButton
        }
    }
    fileprivate func goToLocation(_ locationString: String) {
        preLocation()
        
        
        CLGeocoder().geocodeAddressString(locationString) { (placemark, error) in
            self.posLocation()
            guard error == nil else {
                let alert = UIAlertController.init(title: "Tá no mapa", message: "Local não encontrado", preferredStyle: .alert)
                let okButton = UIAlertAction.init(title: "ok", style: .default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            self.performSegue(withIdentifier: "segueShowNewLocation", sender: placemark!.first?.location?.coordinate)
        }
    }
   
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
    
    @IBAction func dismiss(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
