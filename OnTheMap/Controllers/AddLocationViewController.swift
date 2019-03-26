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
    
    var loggedUser: User!
    var parseClient: ParseApiProtocol!
    var studentInformation: StudentInformation?
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var linkTextField: UITextField!
    
    @IBOutlet weak var locationButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let SEGUE = "addLocationSegue"
    
    var userLocation: MKUserLocation?
    var searchedPlacemark: MKPlacemark?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        precondition(loggedUser != nil)
        precondition(parseClient != nil)
        
        if let userInformation = studentInformation {
            locationTextField.text = userInformation.mapTextReference
            linkTextField.text = userInformation.mediaUrl.absoluteString
        }
        locationTextField.text = ""
        linkTextField.text = ""

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @IBAction func findLocation(_ sender: UIButton?) {
        
        guard let locationText = locationTextField.text, !locationText.isEmpty,
              let linkText = linkTextField.text, !linkText.isEmpty else {
            print("Fill ALL FIELDS !")
            return
        }
        
        sender?.isEnabled = false
        
        let locationSearchRequest = MKLocalSearch.Request()
        locationSearchRequest.naturalLanguageQuery = locationText
        if let userLocation = userLocation {
            let userRegion = MKCoordinateRegion(
                center: userLocation.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100)
            )
            locationSearchRequest.region = userRegion
        }
        locationButton.isEnabled = false
        activityIndicator.startAnimating()
        
        [locationTextField, linkTextField].forEach { $0?.resignFirstResponder() }
        
        let localSearch = MKLocalSearch(request: locationSearchRequest)
        localSearch.start { response, error in
            self.activityIndicator.stopAnimating()
            self.locationButton.isEnabled = true
            
            guard error == nil, let response = response, !response.mapItems.isEmpty else {
                self.displayError(.lackingData, withMessage: "Location not found, try something different!")
                return
            }
            
            let firstResult = response.mapItems.first!
            
            self.searchedPlacemark = firstResult.placemark
            self.performSegue(withIdentifier: self.SEGUE, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Pass the informations to next screen
        let location = locationTextField.text!
        let linkText = linkTextField.text!
        
        if let detailsController = segue.destination as? LocationDetailsViewController {
            detailsController.locationText = location
            detailsController.linkText = linkText
            detailsController.placemark = searchedPlacemark
            detailsController.loggedUser = loggedUser
            detailsController.parseClient = parseClient
            detailsController.studentInformation = studentInformation
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return searchedPlacemark != nil
    }

}
