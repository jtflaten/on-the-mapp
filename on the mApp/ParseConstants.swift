//
//  ParseConstants.swift
//  on the mApp
//
//  Created by Jake Flaten on 3/21/17.
//  Copyright © 2017 Break List. All rights reserved.
//

import Foundation

//MARK: ParseClient - (Constants)

extension ParseClient {
    
    //MARK: Constants
    struct Constants {
        //MARK: API Key
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ApiKeyHeaderField = "X-Parse-REST-API-Key"
        static let AppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let AppIDHeaderField = "X-Parse-Application-Id"
        //MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
    }
    
    //MARK: Methods
    struct Methods {
        static let StudentLocation = "/StudentLocation"
        //MARK: Account
        //MARK: Authentication
        //MARK: Search
        //MARK: Congfig
    }
    
    //MARK: URL Keys
    struct URLKeys{
    
    }
    
    
    //MARK: Parameter Keys
    struct ParameterKeys {
        static let Limit = "limit"
        static let Skip = "skip"
        static let Order = "order"
        static let Where = "where"
        
    }
    
    //MARK: JSON Body Keys
    struct JSONBodyKeys{
    
    }
    
    //MARK: JSON Response Keys
    struct JSONResponseKeys{
        //MARK: General
        static let Results = "results"
        static let ObjectID = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaUrl = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
        static let accessControlList = "ACL"
        //MARK: Authorization
        //MARK: Acount
        //MARK: Config
        //MARK: Student Locations
    }
}
