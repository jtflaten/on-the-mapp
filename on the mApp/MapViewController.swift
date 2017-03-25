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
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
   
    override func viewWillAppear(_ animated: Bool) {
        // Do any additional setup after loading the view, typically from a nib.
        super.viewWillAppear(animated)
        self.students = StudentLocation.studentLocationArray
        var mapAnnotations = [MKPointAnnotation]()
        var stundentDicts = students
        
        print("its\(stundentDicts.count)")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

