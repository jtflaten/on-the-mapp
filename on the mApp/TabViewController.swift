//
//  TabViewController.swift
//  on the mApp
//
//  Created by Jake Flaten on 3/24/17.
//  Copyright © 2017 Break List. All rights reserved.
//

import Foundation
import UIKit
class MapTabViewController: UITabBarController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
      
        getStudentLocations()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getStudentLocations()
        print("tabView")
    }
    
    func getStudentLocations () {
        ParseClient.sharedInstance().getStudentLocations { (studentLocations, error) in
        
            performUIUpdatesOnMain {
            
            if let studentLocations = studentLocations {
                StudentLocation.studentLocationArray = studentLocations
                
                } else {
                print("what?")
                }
        
            }
            print("tabView\(StudentLocation.studentLocationArray.count)")
            
        }
    }

}
