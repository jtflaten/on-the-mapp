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
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: #imageLiteral(resourceName: "icon_addpin"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(presentPostInfo)),
            UIBarButtonItem(image: #imageLiteral(resourceName: "icon_refresh"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(refreshData))
        ]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(logout))
        getStudentLocations()
        getUserInfo()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getStudentLocations()
    }
    
    func getStudentLocations () {
        ParseClient.sharedInstance().getStudentLocations { (studentLocations, error) in
        
            performUIUpdatesOnMain {
                if error != nil {
                    self.errorAlertView(errorMessage: "There was a network error, we couldn't get the data ")
                    
                }
            if let studentLocations = studentLocations {
                StudentLocation.studentLocationArray = studentLocations
                }
            }
            if let theMap = self.viewControllers?[0] as? MapViewController {
                theMap.loadStudents(studentInfo: StudentLocation.studentLocationArray)
            }
        }
    }
    
    func getUserInfo () {
        UdacityClient.sharedInstance().getUserInfo() { (success, firstName, lastName, error) in
            guard (error == nil) else {
                self.errorAlertView(errorMessage: "couldn't get user's name")
                return
            }
            StudentLocation.userInfo.firstName = firstName
            StudentLocation.userInfo.lastName = lastName
    
        }
    }
    func presentPostInfo()   {
        let postNavController = storyboard!.instantiateViewController(withIdentifier: "postNavigationController") as! UINavigationController
        present(postNavController, animated: true)
    }
    func refreshData () {
        viewWillAppear(false)
    }
    func logout() {
        UdacityClient.sharedInstance().logoutFromUdacity()
        dismiss(animated: true, completion: nil)
    }

}
