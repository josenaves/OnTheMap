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
    let uniqueKey: String?
    let title: String?
    let firstName: String?
    let lastName: String?
    let latitude: Double?
    let longitude: Double?
    let mediaUrl: String?
    let createdAt: String
    let updatedAt: String
    let ACL: String?
    
    // MARK: Initializers
    
    // construct a TMDBMovie from a dictionary
    init(dictionary: [String:AnyObject]) {
        
        id = dictionary[APIClient.JSONResponseKeys.StudentID] as! String
        uniqueKey = dictionary[APIClient.JSONResponseKeys.StudentUniqueKey] as? String
        title = dictionary[APIClient.JSONResponseKeys.StudentMapString] as? String
        firstName = dictionary[APIClient.JSONResponseKeys.StudentFirstName] as? String
        lastName = dictionary[APIClient.JSONResponseKeys.StudentLastName] as? String
        latitude = dictionary[APIClient.JSONResponseKeys.StudentLatitude] as? Double
        longitude = dictionary[APIClient.JSONResponseKeys.StudentLongitude] as? Double
        mediaUrl = dictionary[APIClient.JSONResponseKeys.StudentMediaUrl] as? String
        createdAt = dictionary[APIClient.JSONResponseKeys.StudentCreated] as! String
        updatedAt = dictionary[APIClient.JSONResponseKeys.StudentUpdated] as! String
        ACL = dictionary[APIClient.JSONResponseKeys.StudentACL] as? String
    }

    static func studentsFromResults(_ results: [[String:AnyObject]]) -> [StudentInformation] {
        
        var students = [StudentInformation]()
        
        // iterate through array of dictionaries, each student is a dictionary
        for result in results {
            students.append(StudentInformation(dictionary: result))
        }
        
        return students
    }

}
