//
//  ViewController.swift
//  Tá no Mapa
//
//  Created by Rodrigo on 29/08/2018.
//  Copyright © 2018 Rodrigo. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController , MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    
    private let kAlertTitle = "On the map"
    private let kInvalidURL = "Invalid input URL"
    private let kOKButtonTitle = "Ok"
    
    // MARK: - UIViewController override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshLocations()
    }
    
    // MARK: IBActions and MapViewController methods
    @IBAction func refreshLocations() {
        let service = TaNoMapaService.init()
        service.locations { (students, errorMessage) in
            if errorMessage != nil  {
                let alert = UIAlertController.init(title: self.kAlertTitle, message: self.kInvalidURL, preferredStyle: .alert)
                let okButton = UIAlertAction.init(title: self.kOKButtonTitle, style: .default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            } else if let students = students {
                self.addAnnotationsStudents(students)
            }
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        self.dismiss(animated: true)
        let service = TaNoMapaService.init()
        service.logout()
    }
    
}

extension MapViewController {
    
    // MARK: - Add annotations methods and MKMapViewDelegate
    
    func addAnnotationsStudents(_ students:[StudentInformation]) {
        var annotations = [MKPointAnnotation]()
        
        for dictionary in students {
            
            if let latitude = dictionary.latitude {
                if let longitude = dictionary.longitude {
                    
                    let latitudeLocationDegress = CLLocationDegrees(latitude.doubleValue)
                    let longitudeLocationDegress = CLLocationDegrees(longitude as! Double)
                    let coordinate = CLLocationCoordinate2D(latitude: latitudeLocationDegress, longitude: longitudeLocationDegress)
                    let firstName = dictionary.firstName
                    let lastName = dictionary.lastName
                    let mediaURL = dictionary.mediaURL
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(firstName ?? String()) \(lastName ?? String())"
                    annotation.subtitle = mediaURL
                    annotations.append(annotation)
                }
            }
        }
        DispatchQueue.main.async {
            self.mapView.addAnnotations(annotations)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinIdentifier = "pinIdentifier"
        var pinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pinIdentifier) as? MKPinAnnotationView
        
        if pinAnnotationView == nil {
            pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinIdentifier)
            pinAnnotationView!.canShowCallout = true
            pinAnnotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        pinAnnotationView!.annotation = annotation
        
        return pinAnnotationView;
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if let urlString = view.annotation?.subtitle! {
            if let url = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.openURL(url)
                } else {
                    let alert = UIAlertController.init(title: self.kAlertTitle, message: self.kInvalidURL, preferredStyle: .alert)
                    let okButton = UIAlertAction.init(title: self.kOKButtonTitle, style: .default, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

}
