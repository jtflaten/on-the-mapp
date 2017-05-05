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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: life cycle
   

    override func viewDidAppear(_ animated: Bool) {
        activityIndicator.hidesWhenStopped = true
    }


    
    //MARK: Actions
    
    @IBAction func signUpPressed(_sender: AnyObject) {
        let signUpUrl = URL(string: "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated")
        let googleSignUp = URL(string: "googlechromes://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated")
//       if UIApplication.shared.canOpenURL(googleSignUp!) {
            UIApplication.shared.open(googleSignUp!, options: [:])
//        } else {
//            UIApplication.shared.open(signUpUrl!, options: [:])
//        }
    }
    
    
    @IBAction func loginPressed(_ sender: Any) {
        activityIndicator.startAnimating()
        if (usernameTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
            self.errorAlertView(errorMessage: "You must enter a username and a password")
            activityIndicator.stopAnimating()
            return
        }
        UdacityClient.sharedInstance().loginThruUdacity(username: usernameTextField.text!, password: passwordTextField.text!, hostViewController: self)
     
        
    //MARK: Login
    }
     func completeLogin() {
        activityIndicator.stopAnimating()
        let controller = storyboard!.instantiateViewController(withIdentifier: "OnTheMapNavController") as! UINavigationController
        present(controller, animated: true, completion: nil)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
