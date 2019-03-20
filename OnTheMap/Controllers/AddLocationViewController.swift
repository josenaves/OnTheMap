//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by José Naves Moura Neto on 18/03/19.
//  Copyright © 2019 José Naves Moura Neto. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController : UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var linkTextField: UITextField!
    
    @IBOutlet weak var locationButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var searchedPlacemark: MKPlacemark?
    
    private let SEGUE = "addLocationSegue"
    
    @IBAction func findLocation(_ sender: UIButton!) {
        print("Find location")
        
        guard let location = locationTextField.text, !location.isEmpty,
              let linkText = linkTextField.text,     !linkText.isEmpty else {
                    
            print("Fill ALL FIELDS !")
            return
        }
        
        sender.isEnabled = false
        
        let locationSearchRequest = MKLocalSearch.Request()
        locationSearchRequest.naturalLanguageQuery = location
        
        locationButton.isEnabled = false
        activityIndicator.startAnimating()
        
        let localSearch = MKLocalSearch(request: locationSearchRequest)
        localSearch.start { response, error in
            self.activityIndicator.stopAnimating()
            self.locationButton.isEnabled = true
            
            guard error == nil, let response = response, !response.mapItems.isEmpty else {
                self.presentAlert(withTitle: "Error", message: "Location not found, try something different!")
                return
            }
            
            /// The placemark searched by the user
            let firstResult = response.mapItems.first!
            
            print("firstResult: \(firstResult)")
            print("Coordinates: \(firstResult.placemark.coordinate)")
            print("countryCode: \(firstResult.placemark.countryCode ?? "?")")
            print("title: \(firstResult.placemark.title ?? "?")")
            print("name: \(firstResult.name ?? "?")")
            
            self.searchedPlacemark = response.mapItems.first!.placemark
            self.performSegue(withIdentifier: self.SEGUE, sender: self)
        }
        
        activityIndicator.stopAnimating()
    }
}
