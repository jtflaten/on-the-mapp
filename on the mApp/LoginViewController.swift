//
//  LoginViewController.swift
//  on the mApp
//
//  Created by Jake Flaten on 3/21/17.
//  Copyright © 2017 Break List. All rights reserved.
//

import Foundation
import UIKit
//MARK: LoginViewCOntroller: UIViewCOntroller
class LoginViewController: UIViewController {
    
    //MARK: Properties

    var userId: String?
    var sessionID: String?
    
    //MARK: Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    //MARK: life cycle
   

   


    
    //MARK: Actions
    
    @IBAction func signUpPressed(_sender: AnyObject) {
        let signUpUrl = URL(string: "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated")
        UIApplication.shared.open(signUpUrl!, options: [:])
    }
    
    
    @IBAction func loginPressed(_ sender: Any) {
        UdacityClient.sharedInstance().loginThruUdacity(username: usernameTextField.text!, password: passwordTextField.text!, hostViewController: self)
        
    //MARK: Login
    }
     func completeLogin() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "OnTheMapNavController") as! UINavigationController
        present(controller, animated: true, completion: nil)
        
    }
}
