//
//  UdacityApiClient.swift
//  OnTheMap
//
//  Created by José Naves Moura Neto on 20/03/19.
//  Copyright © 2019 José Naves Moura Neto. All rights reserved.
//

import Foundation

final class UdacityApiClient: ApiClient, UdacityApiProtocol {
    
    private(set) var userSession: Session?
    private(set) var userAccount: Account?
    private(set) var user: User?

    private lazy var baseURL: URL = {
        guard let url = mountBaseURL(usingScheme: Api.Scheme, host: Api.Host, andPath: Api.Path) else {
            assertionFailure("Could not mount base url!")
            return URL(string: "")!
        }
        
        return url
    }()
    
    override init() {
        super.init()
        
        /// Always remove first 5 chars from returned json, it is a security rule required by the API
        preHandleData = { $0.subdata(in: 5..<$0.count) }
    }
    
    func logIn(
        withUsername username: String,
        password: String,
        andCompletionHandler handler: @escaping (Account?, Session?, ApiClient.RequestError?) -> Void
    ) {
        let bodyText = """
        {
          "udacity": {
            "username": "\(username)",
            "password": "\(password)"
          }
        }
        """
        
        guard let body = bodyText.data(using: .utf8) else {
            assertionFailure("Could not get the data out of the body text!")
            handler(nil, nil, ApiClient.RequestError.malformedJsonBody)
            return
        }
        
        _ = getConfiguredTaskForPOST(
            withAbsolutePath: baseURL.appendingPathComponent(Methods.Session).absoluteString,
            parameters: [:],
            jsonBody: body) { json, error in
                
            guard error == nil else {
                handler(nil, nil, error)
                return
            }
            
            let json = json!
            
            guard let accountData = json[JSONResponseKeys.Account] as? [String: AnyObject],
                let account = Account(data: accountData) else {
                    handler(nil, nil, RequestError.malformedJson)
                    return
            }
            
            guard let sessionData = json[JSONResponseKeys.Session] as? [String: AnyObject],
                let session = Session(data: sessionData) else {
                    handler(nil, nil, RequestError.malformedJson)
                    return
            }
            
            self.userAccount = account
            self.userSession = session
            handler(account, session, nil)
        }
    }

    func logOut(withCompletionHandler handler: @escaping (Bool, ApiClient.RequestError?) -> Void) {
        
        _ = getConfiguredTaskForDELETE(
            withAbsolutePath: baseURL.appendingPathComponent(Methods.Session).absoluteString,
            parameters: [:]) { json, error in
                
            guard error == nil else {
                handler(false, error)
                return
            }
            
            self.user = nil
            self.userSession = nil
            self.userAccount = nil
            handler(true, nil)
        }
    }
    
    func getUserInfo(usingUserIdentifier userID: String,
                     andCompletionHandler handler: @escaping (User?, ApiClient.RequestError?) -> Void) {
        
        let url = baseURL.appendingPathComponent(Methods.User.byReplacingKey(URLKeys.UserID, withValue: userID))
        
        _ = getConfiguredTaskForGET(withAbsolutePath: url.absoluteString, parameters: [:]) { json, error in
            
            guard error == nil else {
                handler(nil, error!)
                return
            }
            
            guard let user = User(userData: json!) else {
                handler(nil, RequestError.malformedJson)
                return
            }
            
            self.user = user
            handler(user, nil)
        }
    }
}

extension UdacityApiClient {
    
    // MARK: Constants
    
    /// The constants used to generate an url to access a resource in the API.
    enum Api {
        static let Scheme = "https"
        static let Host = "onthemap-api.udacity.com"
        static let Path = "/v1"
    }
    
    /// The keys to be replaced with real values in the API methods to be called.
    enum URLKeys {
        static let UserID = "user_id"
    }
    
    /// The methods used in the API.
    enum Methods {
        static let Session = "session"
        static let User = "users/{\(URLKeys.UserID)}"
    }
    
    /// The keys to access the data in the returned json data.
    enum JSONResponseKeys {
        static let Account = "account"
        static let AccountKey = "key"
        static let AccountRegistered = "registered"
        static let Session = "session"
        static let SessionID = "id"
        static let SessionExpiration = "expiration"
        static let User = "user"
        static let UserFirstName = "first_name"
        static let UserLastName = "last_name"
        static let UserKey = "key"
    }
}
