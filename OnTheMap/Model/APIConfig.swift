//
//  APIConfig.swift
//  OnTheMap
//
//  Created by José Naves Moura Neto on 23/02/19.
//  Copyright © 2019 José Naves Moura Neto. All rights reserved.
//

import Foundation

class APIConfig: NSObject, NSCoding {
    
    // MARK: Initialization
    override init() {}
    
    required init?(coder aDecoder: NSCoder) {
    }

    func encode(with aCoder: NSCoder) {
    }

//
//
//    // MARK: Properties
//
//    var baseUrlString = "https://parse.udacity.com/parse/classes"
//    var secureBaseImageURLString =  "https://image.tmdb.org/t/p/"
//    var posterSizes = ["w92", "w154", "w185", "w342", "w500", "w780", "original"]
//    var profileSizes = ["w45", "w185", "h632", "original"]
//    var dateUpdated: Date? = nil
//
//    // MARK: Initialization
//
//    override init() {}
//
//    convenience init?(dictionary: [String:AnyObject]) {
//
//        self.init()
//
//        if let imageDictionary = dictionary[APIClient.JSONResponseKeys.ConfigImages] as? [String:AnyObject],
//
//            baseImageURLString = urlString
//            secureBaseImageURLString = secureURLString
//            posterSizes = posterSizesArray
//            profileSizes = profileSizesArray
//            dateUpdated = Date()
//        } else {
//            return nil
//        }
//    }

}
