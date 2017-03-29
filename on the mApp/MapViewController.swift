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
    var students: [StudentLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parent!.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: #imageLiteral(resourceName: "icon_addpin"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(pushToPostInfo)),
            UIBarButtonItem(image: #imageLiteral(resourceName: "icon_refresh"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(refreshData))
        ]
        parent!.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(logout))
    }

    override func viewWillAppear(_ animated: Bool) {
    // Do any additional setup after loading the view, typically from a nib.
    super.viewWillAppear(true)
    self.students = StudentLocation.studentLocationArray
    loadStudents(studentInfo: StudentLocation.studentLocationArray)
    }
    
    
    func loadStudents(studentInfo: [StudentLocation]) {
        var mapAnnotations = [MKPointAnnotation]()
        let stundentDicts = self.students
        
        print("its\(stundentDicts.count)")
        
        for dictionary in stundentDicts {
            let lat = CLLocationDegrees(dictionary.lat!)
            let long = CLLocationDegrees(dictionary.long!)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let name = dictionary.firstName
            let link = dictionary.link!
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = name
            annotation.subtitle = link
            
            mapAnnotations.append(annotation)
        }
        self.mapView.addAnnotations(mapAnnotations)
        print("map anntations \(mapAnnotations.count)")
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
                app.open(toOpen, options: [:], completionHandler: nil)
            }
        }
    }
    

   
    func pushToPostInfo()   {
        let postViewController = storyboard!.instantiateViewController(withIdentifier: "PostInfoViewController") as! PostInfoViewController
        self.navigationController!.pushViewController(postViewController, animated: true)
    }
    func refreshData () {
        viewWillAppear(false)
    }
    func logout() {
        dismiss(animated: true, completion: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

