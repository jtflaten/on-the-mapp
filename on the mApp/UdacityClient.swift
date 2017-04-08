//
//  UdacityClient.swift
//  on the mApp
//
//  Created by Jake Flaten on 3/21/17.
//  Copyright © 2017 Break List. All rights reserved.
//

import Foundation
import UIKit

class UdacityClient: NSObject {
    //MARK: Properties
    var sessionID : String?
    //MARK: Initializers
    
    
   
    //MARK: Helpers
    
    //MARK: POST session, Login
    func loginThruUdacity(username: String, password: String, hostViewController: LoginViewController! ) {
        
        let badCredentialsAlert = UIAlertController()
        let dismissAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default) { action in
            badCredentialsAlert.dismiss(animated: true, completion: nil)
        }
        badCredentialsAlert.title = "Uh-Oh"
        badCredentialsAlert.message = "There seems to be something wrong with your username or password"
        badCredentialsAlert.addAction(dismissAction)
        
        let otherFailureAlert = UIAlertController()
        let dismissFaiure = UIAlertAction(title: "ok", style: UIAlertActionStyle.default) { action in
            otherFailureAlert.dismiss(animated: true, completion: nil)
        }
        otherFailureAlert.title = "Uh-Oh"
        otherFailureAlert.message = "There was a problem connecting"
        otherFailureAlert.addAction(dismissFaiure)
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            // if an error occurs, print it and re-enable the UI
            func displayError(_ error: String) {
                performUIUpdatesOnMain {
                    print(error)
                    hostViewController.present(otherFailureAlert, animated: true, completion: nil)
                }
            }
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                displayError("There was an error with your request: \(String(describing: error))")
                return
            }
            /* GUARD: Did we get a successful 2XX response? */
            if (response as? HTTPURLResponse)?.statusCode == 400 {
                hostViewController.present(badCredentialsAlert, animated: true, completion: nil)
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                print(response)
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
            guard let accountDict = parsedLoginResult["account"] as? [String: AnyObject] else {
                displayError("couldn't find account")
                return
            }
            guard let sessionDict = parsedLoginResult["session"] as? [String: AnyObject] else {
                displayError("couldn't find 'session'")
                return
            }
            if (sessionDict["id"] as? String) != nil {
                performUIUpdatesOnMain {
                    self.sessionID = sessionDict["id"] as? String
                }
            }else {
                displayError("couldn't find 'id'")
                return
            }
            if (accountDict["key"] as? String) != nil {
                performUIUpdatesOnMain {
                    hostViewController.completeLogin()
                    StudentLocation.userInfo.uniqueKey = (accountDict["key"] as? String)
                }
            }else {
                displayError("couldn't find 'id'")
                return
            }
            
            
            
        }
        task.resume()
        
    }
    
    //MARK: GET seesion, get the user's data
    func taskforGETMethod(completionHandlerForGET: @escaping (_ parsedResponse: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        let userID = StudentLocation.userInfo.uniqueKey!
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/users/\(userID)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError(error: "There was an error with your request: \(String(describing: error))")
                
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
                sendError(error: "Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError(error: "No data was returned by the request!")
                return
            }
            let newData = data.subdata(in: Range(uncheckedBounds: (5, data.count)))
            
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForGET)
        
        }
        task.resume()
       
        return task
       
    }
    
    func getUserInfo(completionHandlerForUserInfo: @escaping (_ success: Bool, _ firstName: String?, _ lastName: String?, _ error: NSError?) -> Void) {
        let _ = taskforGETMethod() { (parsedResponse, error) in
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForUserInfo(false, nil, nil, NSError(domain: "completionHandlerForGET", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError(error: "There was an error with your request: \(String(describing: error))")
                return
            }
            
            guard (parsedResponse != nil) else {
                sendError(error: "No results were found.")
                return
            }
            guard let user = parsedResponse?["user"] as! [String: AnyObject]? else {
                sendError(error: "coulnd't find user")
                return
            }
            guard let firstName = user["first_name"] as! String? else {
                sendError(error: "couldn't find first name")
                return
            }
            guard let lastName = user["last_name"] as! String? else {
                sendError(error: "couldn't finnd last name")
                return
            }
            return completionHandlerForUserInfo(true, firstName, lastName, nil)
        }
    }
    
    //MARK: DELETE session, Logout
    func logoutFromUdacity() {
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = Range(5 ..< data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
        
        }
        task.resume()
    }
    //MARK: Helper funcs
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
       //MARK: Shared Instance
    class func sharedInstance() -> UdacityClient{
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}
