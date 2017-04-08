//
//  PostLinkViewController.swift
//  on the mApp
//
//  Created by Jake Flaten on 3/29/17.
//  Copyright © 2017 Break List. All rights reserved.
//

import UIKit
import MapKit
import Foundation

class PostLinkViewController: UIViewController {
    
    
    @IBOutlet weak var locationMapView: MKMapView!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addButton: UIButton!
  
    
    var mapString: String?
 
    var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
         self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancel))
       
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        showPinOnMap()

    }
    
    func showPinOnMap() {
        geocoder.geocodeAddressString(mapString!) { (placemarks, error) in
            if error != nil {
                self.activityIndicator.stopAnimating()
                self.navigationController!.popViewController(animated: true)
                self.errorAlertView(errorMessage: "had trouble geocoding the location")
                
            }
            if let placemarks = placemarks {
                for cLPlacemark in placemarks {
                    StudentLocation.userInfo.lat = cLPlacemark.location?.coordinate.latitude
                    StudentLocation.userInfo.long = cLPlacemark.location?.coordinate.longitude
                    StudentLocation.userInfo.mapString = self.mapString!
                    
                    let mapPlacemark = MKPlacemark(placemark: cLPlacemark)
                    self.locationMapView.addAnnotation(mapPlacemark)
                   
                    
                    self.locationMapView.centerCoordinate = (mapPlacemark.location?.coordinate)!
                    let coordinateSpan = MKCoordinateSpanMake(0.65,0.65)
                    let coordinateRegion = MKCoordinateRegion(center: (mapPlacemark.location?.coordinate)!, span: coordinateSpan)
                    self.locationMapView.setRegion(coordinateRegion, animated: true)
                    
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }


    
    @IBAction func addToMapPressed(_ sender: Any) {
        StudentLocation.userInfo.link = linkTextField.text
        let url = URL(string: linkTextField.text!)
        if !UIApplication.shared.canOpenURL(url!) {
            errorAlertView(errorMessage: "That's not a URL that safari can open.")
            return
        }
        
        if let uniqueKey = StudentLocation.userInfo.uniqueKey,
        let firstName = StudentLocation.userInfo.firstName,
        let lastName = StudentLocation.userInfo.lastName,
        let latitude = StudentLocation.userInfo.lat,
        let longitude = StudentLocation.userInfo.long,
        let mediaURL = StudentLocation.userInfo.link,
        let mapString = StudentLocation.userInfo.mapString {
        
            let jsonForRequest = "{\"uniqueKey\":\"\(uniqueKey)\",\"firstName\":\"\(firstName)\",\"lastName\":\"\(lastName)\",\"mapString\":\"\(mapString)\",\"mediaURL\":\"\(mediaURL)\",\"latitude\": \(latitude),\"longitude\":\(longitude)}"
            
            if StudentLocation.userInfo.objectId == nil {
                ParseClient.sharedInstance().postToParse(userLocation: jsonForRequest) {(objectId, error) in
                    performUIUpdatesOnMain {

                        if error == nil {
                                self.parent!.dismiss(animated: true)
                        } else {
                            self.errorAlertView(errorMessage: "attempt failed. Can't get you on the map")
                        }
                        
                    }
                }
            } else {
                ParseClient.sharedInstance().putToParse(userLocation: jsonForRequest) {( updatedAt, error) in
                    performUIUpdatesOnMain {
                        if error == nil {
                            self.navigationController!.popToRootViewController(animated: true)
                        } else {
                            self.errorAlertView(errorMessage: "attempt failed. Can't update your place on the map")
                        }
                    }
                }
            }
        }
    }
    
    func cancel(){
        self.navigationController!.popToRootViewController(animated: true)
    }
}
