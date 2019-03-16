//
//  AnnotationTapRecognizer.swift
//  OnTheMap
//
//  Created by José Naves Moura Neto on 16/03/19.
//  Copyright © 2019 José Naves Moura Neto. All rights reserved.
//

import UIKit

class AnnotationTapRecognizer: UITapGestureRecognizer {
    
    // MARK: Properties
    var link: String
    
    // MARK: Initializers
    
    init(target: Any?, action: Selector?, link: String) {
        self.link = link
        super.init(target: target, action: action)
    }
}
