//
//  APIConvenience.swift
//  OnTheMap
//
//  Created by José Naves Moura Neto on 25/02/19.
//  Copyright © 2019 José Naves Moura Neto. All rights reserved.
//

import UIKit
import Foundation

// MARK: - APIClient (Convenient Resource Methods)

extension APIClient {
    
    // MARK: GET Convenience Methods
    func getStudents(_ completionHandler: @escaping (_ result: [StudentInformation]?, _ error: NSError?) -> Void) {
        // 1 - Specify parameters, method (if has {key}, and HTTP body (if POST)
        let parameters = [APIClient.ParameterKeys.Limit: 100]
        let method: String = Methods.StudentLocations
        
        // 2 - Make the request
        let _ = taskForGETMethod(method, parameters: parameters as [String:AnyObject]) { (results, error) in
            
            // 3 - Send the desired values(s) to completion handler
            if let error = error {
                completionHandler(nil, error)
            } else {
                if let results = results?[APIClient.JSONResponseKeys.StudentResults] as? [[String:AnyObject]] {
                    let students = StudentInformation.studentsFromResults(results)
                    completionHandler(students, nil)
                } else {
                    completionHandler(nil, NSError(domain: "getStudentsLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentsLocations"]))
                }
            }
        }
    }
    
}
