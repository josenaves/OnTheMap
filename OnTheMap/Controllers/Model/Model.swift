//
//  Model.swift
//  OnTheMap
//
//  Created by José Naves Moura Neto on 16/03/19.
//  Copyright © 2019 José Naves Moura Neto. All rights reserved.
//

import Foundation

class Model: NSObject {
    static let shared: Model = Model()

    var students = [StudentInformation]()
}
