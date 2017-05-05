//
//  ParseClient.swift
//  on the mApp
//
//  Created by Jake Flaten on 3/21/17.
//  Copyright © 2017 Break List. All rights reserved.
//
// Some of the code in this project is based upon code from Udacity's TheMovieManager app 
// When i got stuck with some of the networking tasks, I also looked at Christine Chang's repo for this same project. https://github.com/xtnchang/On-the-Map

import Foundation

// MARK: - ParseClient: NSObject

class ParseClient: NSObject {
 
    //MARK: Properties
    var session = URLSession.shared
    //MARK: Initializers
    //MARK: GET
    func taskForGETMethod(_ method: String, parameters: [String:AnyObject]?, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        //Set the parameters
//        var urlString = Constants.parseUrl + method
//        if let parameters = parameters {
//            urlString = (Constants.parseUrl + method + parameters)
        var urlString = buildURLFromParameters(parameters, withPathExtension: method)
        
      
        let url = urlString
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: url as URL)
        request.addValue(Constants.AppID, forHTTPHeaderField: Constants.AppIDHeaderField)
        request.addValue(Constants.ApiKey, forHTTPHeaderField: Constants.ApiKeyHeaderField)
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(String(describing: error))")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    //   MARK: GET methods
    
    func getStudentLocations(_ completionHandlerForStudentLocations: @escaping (_ result: [StudentLocation]?, _ error: NSError?) -> Void){
        let parameters = [ParseClient.ParameterKeys.Limit:100, ParameterKeys.Order: "-updatedAt"] as [ String: AnyObject]
        let method = String(Methods.StudentLocation)
        
        let _ = taskForGETMethod(method!, parameters: parameters ) { (results, error) in
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForStudentLocations(nil, NSError(domain: "completionHandlerForGET", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError(error: "there was a error in the request: \(String(describing: error))")
                return
            }
            guard (results != nil) else {
                sendError(error: "no response")
                return
            }
            guard let studentLocations = results?[JSONResponseKeys.Results] as? [[String:AnyObject]]? else {
                sendError(error: "noResultsFound")
                return
            }
            performUIUpdatesOnMain {
                let students = StudentLocation.studentLocationsFromResults(studentLocations!)
                completionHandlerForStudentLocations(students, nil)
                StudentLocation.studentLocationArray = StudentLocation.studentLocationsFromResults(studentLocations!)
            }
        }
    }
    
    func getUserStudentLocation(_ completionHandlerForUserLocation: @escaping (_ userLocation: [[String: AnyObject]]?, _ error: NSError?) -> Void) {
        let parameters = ["\(ParameterKeys.Where)":["{\(JSONResponseKeys.UniqueKey)":"\(StudentLocation.userInfo.uniqueKey!)}"]] as [String: AnyObject]
        let method = String(Methods.StudentLocation)
        
        let url = taskForGETMethod(method!, parameters: parameters) { (results, error) in

            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForUserLocation(nil, NSError(domain: "completionHandlerForGETstudent", code: 1, userInfo: userInfo))
            }
            guard (error == nil) else {
                sendError(error: "there was a error in the request")
                return
            }
            guard (results != nil) else {
                sendError(error: "no response")
                return
            }
            guard let userLocation = results?[JSONResponseKeys.Results] as? [[String:AnyObject]] else{
                sendError(error: "couldn't get the single student results")
                return
            }
            performUIUpdatesOnMain {
            
            completionHandlerForUserLocation(userLocation,nil)
        
            }
            
        }
    }
    
    //MARK: POST
    
    func taskForPOSTMethod(_ method: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        /* 1. set the parameters
         2. Build the URL
         3. Configure the request
         4. Make the request
         5. Parse the data
         6. Use the data
         7. start the request
         */
        let urlstring = Constants.parseUrl + method
        let url = URL(string: urlstring)
        let request = NSMutableURLRequest(url: url! )
         let jsonBody = makeJsonForRequest()
        request.httpMethod = "POST"
        request.addValue(Constants.AppID, forHTTPHeaderField: Constants.AppIDHeaderField)
        request.addValue(Constants.ApiKey, forHTTPHeaderField: Constants.ApiKeyHeaderField)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(String(describing: error))")
                return
            }
            
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
         
        
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }

    
    //MARK: POST methods
    
    func postToParse(completionHandlerForPost: @escaping (_ objectID: String?, _ error: NSError?) -> Void) {
        let _ = taskForPOSTMethod(Methods.StudentLocation) { (parsedResponse, error) in
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPost(nil, NSError(domain: "completionHandlerForPOST", code: 1, userInfo: userInfo))
            }
            guard (error == nil) else {
                sendError(error: "there was an error with the request: \(String(describing: error))")
                return
            }
            guard (parsedResponse != nil) else {
                sendError(error: "no response")
                return
            }
            guard let objectID = parsedResponse?[ParseClient.JSONResponseKeys.ObjectID]  as! String? else {
                sendError(error: "no object ID found in the post response")

                return
            }
            StudentLocation.userInfo.objectId = objectID
            completionHandlerForPost(objectID , nil)
    
        }
    }
    
    //MARK: PUT
    func taskForPUTMethod(method: String, parameter: String, completionHandlerForPUT: @escaping ( _ result: AnyObject?, _ error: NSError?) -> Void ) -> URLSessionDataTask {
        let urlString = Constants.parseUrl + method + parameter
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!)
        let jsonBody = makeJsonForRequest()
        request.httpMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        let task = session.dataTask(with: request as URLRequest) { ( data, response, error) in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPUT(nil, NSError(domain: "taskForPUTMethod", code: 1, userInfo: userInfo))
            }
            guard error == nil else {
                sendError("an error occurred: \(String(describing: error))")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                print("response: \(String(describing: response))")
                return
            }
            guard let data = data else {
                sendError("no data was returned by request")
                return
            }
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPUT)
        }
        task.resume()
        return task
    }
    
    //MARK: PUT Method
    
    func putToParse(completionHandlerForPut: @escaping(_ updatedAt: String?, _ error: NSError?) -> Void) {
        let _ = taskForPUTMethod(method: Methods.StudentLocation, parameter: StudentLocation.userInfo.objectId!) { (parsedResponse, error) in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPut(nil, NSError(domain: "taskForPUTMethod", code: 1, userInfo: userInfo))
            }
            guard error == nil else {
                sendError(" there was an error with the put request: \(String(describing: error))")
                return
            }
            guard let updatedAt = parsedResponse?[ParseClient.JSONResponseKeys.UpdatedAt] as! String? else {
                sendError("couldn't find the updated at")
                return
            }
            StudentLocation.userInfo.updatedAt = updatedAt
            completionHandlerForPut(updatedAt, nil)
        }
    }
    //MARK: Helpers
    // given raw JSON, return a usable Foundation object
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
    
    private func buildURLFromParameters(_ parameters: [String:AnyObject]?, withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = ParseClient.Constants.ApiScheme
        components.host = ParseClient.Constants.ApiHost
        components.path = ParseClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        if let parameters = parameters {
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        return components.url!
    }
  
    func makeJsonForRequest() -> String  {
        var jsonForRequest = ""
        if let uniqueKey = StudentLocation.userInfo.uniqueKey,
            let firstName = StudentLocation.userInfo.firstName,
            let lastName = StudentLocation.userInfo.lastName,
            let latitude = StudentLocation.userInfo.lat,
            let longitude = StudentLocation.userInfo.long,
            let mediaURL = StudentLocation.userInfo.link,
            let mapString = StudentLocation.userInfo.mapString {
            
            jsonForRequest = "{\"uniqueKey\":\"\(uniqueKey)\",\"firstName\":\"\(firstName)\",\"lastName\":\"\(lastName)\",\"mapString\":\"\(mapString)\",\"mediaURL\":\"\(mediaURL)\",\"latitude\": \(latitude),\"longitude\":\(longitude)}"
            
        }
        return jsonForRequest
    }
    
   
    //MARK: Shared Instance
    
    class func sharedInstance() -> ParseClient{
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance 
    }
    
}
