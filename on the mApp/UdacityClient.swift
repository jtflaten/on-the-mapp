//
//  UdacityClient.swift
//  on the mApp
//
//  Created by Jake Flaten on 3/21/17.
//  Copyright © 2017 Break List. All rights reserved.
//

import Foundation


class UdacityClient: NSObject {
    //MARK: Properties
    //MARK: Initializers
    //MARK: POST session
    //MARK: DELETE session
   
    //MARK: Helpers
    //MARK: Shared Instance
    func logInThroughUdacity (_ sessionID: String) {
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \")\", \"password\": \"cheeseBzrger2\"}}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = Range(5 ..< data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
    }
}
