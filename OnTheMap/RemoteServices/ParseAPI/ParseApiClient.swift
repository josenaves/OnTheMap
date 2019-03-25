//
//  ParseApiClient.swift
//  OnTheMap
//
//  Created by José Naves Moura Neto on 20/03/19.
//  Copyright © 2019 José Naves Moura Neto. All rights reserved.
//

import Foundation

class ParseApiClient: ApiClient, ParseApiProtocol {
    
    var studentLocations = [StudentInformation]()

    private lazy var baseURL: URL = {
        guard let url = mountBaseURL(usingScheme: Api.Scheme, host: Api.Host, andPath: Api.Path) else {
            assertionFailure("Could not mount the url!")
            return URL(string: "")!
        }
        return url
    }()

    override init() {
        super.init()
        
        requiredApiHeaders = [
            "X-Parse-Application-Id": "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr",
            "X-Parse-REST-API-Key": "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        ]
    }

    func fetchStudentLocations(
        withLimit limit: Int,
        skippingPages pagesToSkip: Int,
        andUsingCompletionHandler handler: @escaping ([StudentInformation]?, ApiClient.RequestError?) -> Void
    ) {
        
        let fetchUrl = baseURL.appendingPathComponent(Methods.StudentLocation)
        let parameters = [
            ParameterKeys.Order: "-\(JSONResponseKeys.UpdatedAt)",
            ParameterKeys.Limit: String(limit),
            ParameterKeys.Page: String(pagesToSkip * limit)
        ]
        
        _ = getConfiguredTaskForGET(withAbsolutePath: fetchUrl.absoluteString, parameters: parameters) { json, error in
            
            guard error == nil else {
                handler(nil, error!)
                return
            }
            
            let json = json!
            
            guard let results = json[JSONResponseKeys.Results] as? [[String: AnyObject]] else {
                handler(nil, RequestError.malformedJson)
                return
            }
            
            let locations = results.compactMap { StudentInformation(dictionary: $0) }
            
            assert(!locations.isEmpty, "The mapped locations mustn't be empty.")
            
            self.studentLocations = locations
            handler(locations, nil)
        }
    }
    
    func fetchStudentLocation(
        byUsingUniqueKey key: String,
        andCompletionHandler handler: @escaping (StudentInformation?, ApiClient.RequestError?) -> Void
    ) {
        
        let fetchUrl = baseURL.appendingPathComponent(Methods.StudentLocation)
        let parameters = [ParameterKeys.WhereQuery: "{\"\(JSONResponseKeys.InformationKey)\" : \"\(key)\"}"]
        _ = getConfiguredTaskForGET(withAbsolutePath: fetchUrl.absoluteString, parameters: parameters)  { json, error in
            guard error == nil, let json = json else {
                handler(nil, error!)
                return
            }
            
            guard let results = json[JSONResponseKeys.Results] as? [[String: AnyObject]], !results.isEmpty else {
                handler(nil, ApiClient.RequestError.malformedJson)
                return
            }
            
            guard let fetchedInformation = StudentInformation(dictionary: results.first!) else {
                handler(nil, ApiClient.RequestError.malformedJson)
                return
            }
            
            handler(fetchedInformation, nil)
        }
    }

    func createStudentLocation(
        _ information: StudentInformation,
        withCompletionHandler handler: @escaping (StudentInformation?, ApiClient.RequestError?) -> Void
    ) {
        manageCurrentUserStudentLocation(information, usingMethod: .post, andCompletionHandler: handler)
    }
    
    func updateStudentLocation(
        _ information: StudentInformation,
        withCompletionHandler handler: @escaping (StudentInformation?, ApiClient.RequestError?) -> Void
    ) {
        manageCurrentUserStudentLocation(information, usingMethod: .put, andCompletionHandler: handler)
    }

    private func manageCurrentUserStudentLocation(
        _ information: StudentInformation,
        usingMethod method: ApiClient.HTTPMethod,
        andCompletionHandler handler: @escaping (StudentInformation?, ApiClient.RequestError?) -> Void
    ) {
        
        guard let jsonData = getJsonRepresentation(ofStudentInformation: information) else {
            assertionFailure("Couldn't get the student information json body data.")
            handler(nil, ApiClient.RequestError.malformedJsonBody)
            return
        }
        
        let requestCompletionHandler: ([String: AnyObject]?, ApiClient.RequestError?) -> Void = { json, error in
            guard error == nil, let json = json else {
                handler(nil, error!)
                return
            }
            
            var information = information
            
            switch method {
            case .post:
                guard let objectID = json[JSONResponseKeys.ObjectID] as? String else {
                    handler(nil, .malformedJson)
                    return
                }
                guard let updatedAtText = json[JSONResponseKeys.CreatedAt] as? String,
                    let updatedAt = DateFormatter.APIFormatter.date(from: updatedAtText) else {
                        handler(nil, .malformedJson)
                        return
                }
                
                information.objectID = objectID
                information.updatedAt = updatedAt
            case .put:
                guard let updatedAtText = json[JSONResponseKeys.UpdatedAt] as? String,
                    let updatedAt = DateFormatter.APIFormatter.date(from: updatedAtText) else {
                        handler(nil, .malformedJson)
                        return
                }
                
                information.updatedAt = updatedAt
            default: break
            }
            
            handler(information, nil)
        }
        
        var urlString = baseURL.appendingPathComponent(Methods.StudentLocation).absoluteString
        if method == .put {
            guard let objectID = information.objectID else {
                assertionFailure("Could not get the object identifier of the information!")
                handler(nil, ApiClient.RequestError.lackingData)
                return
            }
            
            urlString += "/\(objectID)"
        }
        
        _ = (method == .post ? getConfiguredTaskForPOST : getConfiguredTaskForPUT)(
            urlString,
            [:],
            jsonData,
            requestCompletionHandler
        )
    }
    
    private func getJsonRepresentation(ofStudentInformation studentInformation: StudentInformation) -> Data? {
        let jsonDictionary: [String: Any] = [
            JSONResponseKeys.FirstName: studentInformation.firstName,
            JSONResponseKeys.LastName: studentInformation.lastName,
            JSONResponseKeys.MapTextReference: studentInformation.mapTextReference,
            JSONResponseKeys.Latitude: studentInformation.latitude,
            JSONResponseKeys.Longitude: studentInformation.longitude,
            JSONResponseKeys.MediaUrl: studentInformation.mediaUrl.absoluteString,
            JSONResponseKeys.InformationKey: studentInformation.key
        ]
        return try? JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
    }
}

extension ParseApiClient {
    
    /// The constants used to generate an url to access a resource in the API.
    enum Api {
        static let Scheme = "https"
        static let Host = "parse.udacity.com"
        static let Path = "/parse/classes"
    }
    
    /// The methods used in the API.
    enum Methods {
        static let StudentLocation = "StudentLocation"
    }
    
    /// The keys of the parameters sent in the requests.
    enum ParameterKeys {
        static let Order = "order"
        static let Limit = "limit"
        static let Page = "skip"
        static let WhereQuery = "where"
    }
    
    /// The keys of the json returned in the responses.
    enum JSONResponseKeys {
        static let Results = "results"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapTextReference = "mapString"
        static let MediaUrl = "mediaURL"
        static let InformationKey = "uniqueKey"
        static let ObjectID = "objectId"
        static let UpdatedAt = "updatedAt"
        static let CreatedAt = "createdAt"
    }
    
    /// The keys of the user info that comes with the notifications sent in the notification center.
    enum UserInfoKeys {
        static let CreatedStudentInformation = "created_information"
    }
}

extension NSNotification.Name {
    static let StudentInformationCreated = NSNotification.Name("student_notification_created")
}
