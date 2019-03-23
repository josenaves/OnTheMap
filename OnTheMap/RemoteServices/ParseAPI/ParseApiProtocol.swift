//
//  ParseApiProtocol.swift
//  OnTheMap
//
//  Created by José Naves Moura Neto on 20/03/19.
//  Copyright © 2019 José Naves Moura Neto. All rights reserved.
//

import Foundation

protocol ParseApiProtocol {
    
    var studentLocations: [StudentInformation] { get set }

    func fetchStudentLocations(
        withLimit limit: Int,
        skippingPages pagesToSkip: Int,
        andUsingCompletionHandler handler: @escaping ([StudentInformation]?, ApiClient.RequestError?) -> Void
    )
    
    func fetchStudentLocation(
        byUsingUniqueKey key: String,
        andCompletionHandler handler: @escaping (StudentInformation?, ApiClient.RequestError?) -> Void
    )

    func createStudentLocation(
        _ information: StudentInformation,
        withCompletionHandler handler: @escaping (StudentInformation?, ApiClient.RequestError?) -> Void
    )
    
    func updateStudentLocation(
        _ information: StudentInformation,
        withCompletionHandler handler: @escaping (StudentInformation?, ApiClient.RequestError?) -> Void
    )

    func sortLocations()
}
