//
//  ShowNewLocationViewController.swift
//  Tá no Mapa
//
//  Created by Rodrigo on 11/09/2018.
//  Copyright © 2018 Rodrigo. All rights reserved.
//

import UIKit
import MapKit

class ShowNewLocationViewController: UIViewController {
    
    var coordinate:CLLocationCoordinate2D?
    var locationString:String?
    var urlString:String?
    
    var annotation = MKPointAnnotation()
    
    @IBOutlet weak var mKMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showCoordinate(coordinate: self.coordinate!)
    }

    
    private func showCoordinate(coordinate: CLLocationCoordinate2D) {
        
        annotation.coordinate = coordinate
        annotation.title = locationString
        annotation.subtitle = urlString
        
        let region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.01, 0.01))
        
        DispatchQueue.main.async {
            self.mKMapView.addAnnotation(self.annotation)
            
            self.mKMapView.setRegion(region, animated: true)
            self.mKMapView.regionThatFits(region)
            
        }
        
    }
    

    @IBAction func createLocation(_ sender: Any) {
        TaNoMapaService.addUser(annotation: annotation) { (success) in
            if success {
                self.navigationController?.dismiss(animated: true, completion: nil)
            } else {
                let kErrorTitle = "Error"
                let kOkButtonTitle = "Ok"
                let kMsgErro = "Erro ao adicionar usuário"
                let alert = UIAlertController.init(title: kErrorTitle, message: kMsgErro, preferredStyle: .alert)
                let okButton = UIAlertAction.init(title: kOkButtonTitle, style: .default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }

}
