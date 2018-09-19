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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshLocations()
    }
    
    @IBAction func refreshLocations() {
        let service = TaNoMapaService.init()
        service.locations { (students) in
            self.addAnnotationsStudents(students)
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        self.dismiss(animated: true)
        let service = TaNoMapaService.init()
        service.logout()
    }
    
    
    func addAnnotationsStudents(_ students:[StudentInformation]) {
        var annotations = [MKPointAnnotation]()
        
       
        for dictionary in students {
            
            if let latitude = dictionary.latitude {
                if let longitude = dictionary.longitude {
                    
                    let lat = CLLocationDegrees(latitude.doubleValue)
                    let long = CLLocationDegrees(longitude as! Double)
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let first = dictionary.firstName
                    let last = dictionary.lastName
                    let mediaURL = dictionary.mediaURL
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first ?? String()) \(last ?? String())"
                    annotation.subtitle = mediaURL
                    annotations.append(annotation)
                }
            }
        }
        
        DispatchQueue.main.async {
            self.mapView.addAnnotations(annotations)
        }
        

    }
    
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
    
    
}




