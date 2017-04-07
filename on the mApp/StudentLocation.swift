//
//  StudentLocation.swift
//  on the mApp
//
//  Created by Jake Flaten on 3/22/17.
//  Copyright © 2017 Break List. All rights reserved.
//

import Foundation

struct StudentLocation{
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    var lat: Double?
    var long: Double?
    var link: String?
    var mapString: String?
    var objectId: String?
    var updatedAt: String?
    
    init(dictionary: [String:AnyObject]) {
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as? String
        firstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as? String
        lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as? String
        lat = dictionary[ParseClient.JSONResponseKeys.Latitude] as? Double
        long = dictionary[ParseClient.JSONResponseKeys.Longitude] as? Double
        link = dictionary[ParseClient.JSONResponseKeys.MediaUrl] as? String
        mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as? String
        objectId = dictionary[ParseClient.JSONResponseKeys.ObjectID] as? String
        updatedAt = dictionary[ParseClient.JSONResponseKeys.UpdatedAt] as? String
    }
    
    
    static func studentLocationsFromResults(_ results:[[String:AnyObject]]) -> [StudentLocation] {
        var studentLocations = [StudentLocation]()
        
        for result in results{
            studentLocations.append(StudentLocation(dictionary: result))
        }
        return studentLocations
    }
    
    static var studentLocationArray: [StudentLocation] = []
    static var userInfo = StudentLocation(dictionary: [:])
}
