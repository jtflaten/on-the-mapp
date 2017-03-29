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
        
        let badCredentialsAlert = UIAlertController()
        let dismissAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default) { action in
            self.dismiss(animated: true, completion: nil)
        }
        badCredentialsAlert.title = "Uh-Oh"
        badCredentialsAlert.message = "There seems to be something wrong with your username or password"
        badCredentialsAlert.addAction(dismissAction)
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(usernameTextField.text!)\", \"password\": \"\(passwordTextField.text!)\"}}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            // if an error occurs, print it and re-enable the UI
            func displayError(_ error: String) {
                performUIUpdatesOnMain {
                print(error)
                self.present(badCredentialsAlert, animated: true, completion: nil)
                }
            }
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                displayError("There was an error with your request: \(String(describing: error))")
                return
            }
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
            let range = Range(5 ..< data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            print(request)
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            
            let parsedLoginResult: [String: AnyObject]!
            do {
                parsedLoginResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String: AnyObject]
            } catch {
                displayError("could not parse the Json")
                return
            }
            
            guard let sessionDict = parsedLoginResult["session"] as? [String: AnyObject] else {
                displayError("couldn't find 'session'")
                return
            }
            if (sessionDict["id"] as? String) != nil {
                performUIUpdatesOnMain {
                    self.completeLogin()
                }
            }else {
                displayError("couldn't find 'id'")
                return
            }
            
        }
        task.resume()
        
    }
    //MARK: Login
    func logInThroughUdacity (_ sessionID: String) {
        
            }
     func completeLogin() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "OnTheMapNavController") as! UINavigationController
        present(controller, animated: true, completion: nil)
        
    }
}
