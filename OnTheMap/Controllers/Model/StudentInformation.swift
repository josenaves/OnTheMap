//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by José Naves Moura Neto on 23/02/19.
//  Copyright © 2019 José Naves Moura Neto. All rights reserved.
//

struct StudentInformation {
    
    // MARK: Properties
    let id: String
    let uniqueKey: String
    let title: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mediaUrl: String
    let createdAt: String
    let updatedAt: String
    
    // MARK: Initializers
    
    // construct a TMDBMovie from a dictionary
    init?(dictionary: [String:AnyObject]) {
                
        guard let id = dictionary[APIClient.JSONResponseKeys.StudentID] as? String else {
            print("id is nil")
            return nil
        }
        
        guard let uniqueKey = dictionary[APIClient.JSONResponseKeys.StudentUniqueKey] as? String else {
            print("uniqueKey is nil")
            return nil
        }

        if let title = dictionary[APIClient.JSONResponseKeys.StudentMapString] {
            self.title = title as! String
        } else {
            self.title = "Unknown Title"
        }
        
        if let firstName = dictionary[APIClient.JSONResponseKeys.StudentFirstName] {
            self.firstName = firstName as! String
        } else {
            self.firstName = "Unknown firstName"
        }
        
        if let lastName = dictionary[APIClient.JSONResponseKeys.StudentLastName] {
            self.lastName = lastName as! String
        } else {
            self.lastName = "Unknown lastName"
        }

        guard let latitude = dictionary[APIClient.JSONResponseKeys.StudentLatitude] as? Double else {
            print("latitude is nil")
            return nil
        }
        
        guard let longitude = dictionary[APIClient.JSONResponseKeys.StudentLongitude] as? Double else {
            print("longitude is nil")
            return nil
        }

        guard let mediaUrl = dictionary[APIClient.JSONResponseKeys.StudentMediaUrl] as? String else {
            print("mediaUrl is nil")
            return nil
        }
        
        guard let createdAt = dictionary[APIClient.JSONResponseKeys.StudentCreated] as? String else {
            print("createdAt is nil")
            return nil
        }

        guard let updatedAt = dictionary[APIClient.JSONResponseKeys.StudentUpdated] as? String else {
            print("updatedAt is nil")
            return nil
        }

        self.id = id
        self.uniqueKey = uniqueKey
        self.latitude = latitude
        self.longitude = longitude
        self.mediaUrl = mediaUrl
        self.createdAt = createdAt
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
