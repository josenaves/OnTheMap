//
//  Session.swift
//  OnTheMap
//
//  Created by José Naves Moura Neto on 20/03/19.
//  Copyright © 2019 José Naves Moura Neto. All rights reserved.
//

import Foundation

struct Session {
    
    // MARK: Properties
    
    /// The identifier of the session.
    let identifier: String
    
    /// The expiration date of the session.
    let expiration: Date
    
    // MARK: Initializers
    
    init?(data: [String: AnyObject]) {
        guard let identifier = data[UdacityApiClient.JSONResponseKeys.SessionID] as? String else {
            return nil
        }
        
        guard let expirationString = data[UdacityApiClient.JSONResponseKeys.SessionExpiration] as? String,
            let expiration = DateFormatter.APIFormatter.date(from: expirationString) else {
                return nil
        }
        
        self.identifier = identifier
        self.expiration = expiration
    }
}
