//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by José Naves Moura Neto on 25/02/19.
//  Copyright © 2019 José Naves Moura Neto. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
