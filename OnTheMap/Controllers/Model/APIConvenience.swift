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
    
    // MARK: LOGOUT
    func logout(_ completionHandler: @escaping (_ error: Error?) -> Void) {

        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
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
        let task = session.dataTask(with: request) { data, response, error in
            
            if error != nil {
                print("Error: \(error?.localizedDescription ?? "generic error" )")
                performUIUpdatesOnMain { completionHandler(error) }
                return
            }
            
//            let range = 5 ..< data!.count
//            let newData = data?.subdata(in: range) /* subset response data! */
//
//            print("Now, the response\n")
//            print(String(data: newData!, encoding: .utf8)!)
            
            performUIUpdatesOnMain { completionHandler(nil) }
        }
        task.resume()
    }
    
}
