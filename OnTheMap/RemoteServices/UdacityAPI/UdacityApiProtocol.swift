//
//  UdacityApiProtocol.swift
//  OnTheMap
//
//  Created by José Naves Moura Neto on 20/03/19.
//  Copyright © 2019 José Naves Moura Neto. All rights reserved.
//

import Foundation

protocol UdacityApiProtocol {
    
    var userSession: Session? { get }
    
    var userAccount: Account? { get }

    var user: User? { get }

    func logIn(
        withUsername username: String,
        password: String,
        andCompletionHandler handler: @escaping (Account?, Session?, ApiClient.RequestError?) -> Void
    )

    func logOut(withCompletionHandler handler: @escaping (Bool, ApiClient.RequestError?) -> Void)
    
    func getUserInfo(
        usingUserIdentifier userID: String,
        andCompletionHandler handler: @escaping (User?, ApiClient.RequestError?) -> Void
    )
}
