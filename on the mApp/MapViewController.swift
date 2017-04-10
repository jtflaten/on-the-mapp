//
//  MapViewController.swift
//  on the mApp
//
//  Created by Jake Flaten on 3/20/17.
//  Copyright © 2017 Break List. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
    // Do any additional setup after loading the view, typically from a nib.
    super.viewWillAppear(true)
    mapView.removeAnnotations(mapView.annotations)
    loadStudents(studentInfo: StudentLocation.studentLocationArray)
    
    }
    
    
    func loadStudents(studentInfo: [StudentLocation]) {
        var mapAnnotations = [MKPointAnnotation]()
        let stundentDicts = studentInfo
        
        for dictionary in stundentDicts {
            if dictionary.lat == nil || dictionary.long == nil || dictionary.link == nil || dictionary.firstName == nil || dictionary.lastName == nil {
                continue
            }
            let lat = CLLocationDegrees(dictionary.lat!)
            let long = CLLocationDegrees(dictionary.long!)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let name = dictionary.firstName! + " " + dictionary.lastName!
            let link = dictionary.link!
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = name
            annotation.subtitle = link
            
            mapAnnotations.append(annotation)
        }
        performUIUpdatesOnMain {
            
            self.mapView.addAnnotations(mapAnnotations)
        
            }
    }
   
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
     //to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = URL(string: (view.annotation?.subtitle!)!)  {
                guard app.canOpenURL(toOpen) else {
                    errorAlertView(errorMessage: "couldn't open that URL")
                    return
                }
                app.open(toOpen, options: [:], completionHandler: nil)
            }
        }
    }
}

   





