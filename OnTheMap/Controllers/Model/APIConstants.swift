//
//  APIConstants.swift
//  OnTheMap
//
//  Created by José Naves Moura Neto on 25/02/19.
//  Copyright © 2019 José Naves Moura Neto. All rights reserved.
//

// MARK: APIClient (Constants)

extension APIClient {
    
    //GET /parse/classes/StudentLocation HTTP/1.1
    //Host: parse.udacity.com
    //X-Parse-Application-Id: QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr
    //X-Parse-REST-API-Key: QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY
    //cache-control: no-cache
    
    // MARK: Constants
    struct Constants {
        
        // MARK: Application ID
        static let ApplicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        
        // MARK: API Key
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
        
        // MAKR: Limit
        static let ResultsLimit = "100"
        
        // MARK: Headers
        static let HeaderParseApplicationId = "X-Parse-Application-Id"
        static let HeaderParseApiKey = "X-Parse-REST-API-Key"
    }
    
    // MARK: Methods
    struct Methods {
        // MARK: Students
        static let StudentLocations = "/StudentLocation"
    }

    // MARK: Parameter Keys
    struct ParameterKeys {
        static let Limit = "limit"
        static let Skip = "skip"
        static let Order = "order"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: Students
        static let StudentResults = "results"
        static let StudentID = "objectId"
        static let StudentUniqueKey = "uniqueKey"
        static let StudentMapString = "mapString"
        static let StudentFirstName = "firstName"
        static let StudentLastName = "lastName"
        static let StudentMediaUrl = "mediaURL"
        static let StudentLatitude = "latitude"
        static let StudentLongitude = "longitude"
        static let StudentCreated = "createdAt"
        static let StudentUpdated = "updatedAt"
        static let StudentACL = "ACL"
    }
}
