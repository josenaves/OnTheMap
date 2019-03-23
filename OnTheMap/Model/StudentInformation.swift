//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by José Naves Moura Neto on 23/02/19.
//  Copyright © 2019 José Naves Moura Neto. All rights reserved.
//

import Foundation

struct StudentInformation {
    
    // MARK: Properties
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapTextReference: String
    let mediaUrl: URL
    let key: String
    var objectID: String?
    var updatedAt: Date?

    // MARK: Initializers
    init(firstName: String,
         lastName: String,
         latitude: Double,
         longitude: Double,
         mapTextReference: String,
         mediaUrl: URL,
         key: String
    ) {
        
        self.firstName = firstName
        self.lastName = lastName
        self.latitude = latitude
        self.longitude = longitude
        self.mapTextReference = mapTextReference
        self.mediaUrl = mediaUrl
        self.key = key
    }
    
    // construct a TMDBMovie from a dictionary
    init?(dictionary: [String:AnyObject]) {
        
//        if let firstName = dictionary[ParseApiClient.JSONResponseKeys.FirstName] {
//            self.firstName = firstName as! String
//        } else {
//            self.firstName = "Unknown firstName"
//        }
//
//        if let lastName = dictionary[ParseApiClient.JSONResponseKeys.LastName] {
//            self.lastName = lastName as! String
//        } else {
//            self.lastName = "Unknown lastName"
//        }
        
        guard let firstName = dictionary[ParseApiClient.JSONResponseKeys.FirstName] as? String else {
            return nil
        }
        
        guard let lastName = dictionary[ParseApiClient.JSONResponseKeys.LastName] as? String else {
            return nil
        }

        guard let latitude = dictionary[ParseApiClient.JSONResponseKeys.Latitude] as? Double else {
            print("latitude is nil")
            return nil
        }
        
        guard let longitude = dictionary[ParseApiClient.JSONResponseKeys.Longitude] as? Double else {
            print("longitude is nil")
            return nil
        }

        guard let mediaUrlText = dictionary[ParseApiClient.JSONResponseKeys.MediaUrl] as? String,
              let mediaUrl = URL(string: mediaUrlText) else {
                
            return nil
        }

        guard let mapTextReference = dictionary[ParseApiClient.JSONResponseKeys.MapTextReference] as? String else {
            return nil
        }
        
        guard let objectID = dictionary[ParseApiClient.JSONResponseKeys.ObjectID] as? String else {
            return nil
        }
        
        guard let key = dictionary[ParseApiClient.JSONResponseKeys.InformationKey] as? String else {
            return nil
        }
        
        guard let updatedAtText = dictionary[ParseApiClient.JSONResponseKeys.UpdatedAt] as? String,
            let updatedAt = DateFormatter.APIFormatter.date(from: updatedAtText) else {
            return nil
        }

        self.firstName = firstName
        self.lastName = lastName
        self.latitude = latitude
        self.longitude = longitude
        self.mapTextReference = mapTextReference
        self.mediaUrl = mediaUrl
        self.key = key
        self.objectID = objectID
        self.updatedAt = updatedAt
    }

    static func studentsFromResults(_ results: [[String:AnyObject]]) -> [StudentInformation] {
        
        var students = [StudentInformation]()
        
        // iterate through array of dictionaries, each student is a dictionary
        for result in results {
            if let student = StudentInformation(dictionary: result) {
                students.append(student)
            }
        }
        
        return students
    }

}
