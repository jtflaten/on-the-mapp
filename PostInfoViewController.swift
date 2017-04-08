//
//  PostInfoViewController.swift
//  on the mApp
//
//  Created by Jake Flaten on 3/28/17.
//  Copyright © 2017 Break List. All rights reserved.
//
import Foundation
import UIKit
import MapKit

class PostInfoViewController: UIViewController {
    
    var geocoder = CLGeocoder()
    
    @IBOutlet weak var locationTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancel))
    }
    @IBAction func findButtonPressed(_ sender: Any) {
        let postLinkController = self.storyboard!.instantiateViewController(withIdentifier: "PostLinkViewController") as! PostLinkViewController
        postLinkController.mapString = self.locationTextField.text
        self.navigationController!.pushViewController(postLinkController, animated: true)
        
    }
    
    func cancel(){
        parent!.dismiss(animated: true)
    }
}
