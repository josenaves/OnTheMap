//
//  LocationDetailsViewController.swift
//  OnTheMap
//
//  Created by José Naves Moura Neto on 18/03/19.
//  Copyright © 2019 José Naves Moura Neto. All rights reserved.
//

import UIKit
import MapKit

class LocationDetailsViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var buttonFinish: UIButton!
    
    var loggedUser: User!
    var parseClient: ParseApiProtocol!
    var studentInformation: StudentInformation?
    
    var locationText: String!
    var linkText: String!
    var placemark: MKPlacemark!

    private let annotationViewId = "user_annotation"
    
    private var selectedViewTapRecognizer: UITapGestureRecognizer?

    private lazy var studentInformationToPost: StudentInformation = {
        var currentStudentInformation = makeStudentInformation(
            locationText: locationText,
            placemark: placemark,
            linkText: linkText,
            loggedUser: loggedUser
        )
        
        if studentInformation != nil {
            currentStudentInformation.objectID = studentInformation?.objectID
        }
        return currentStudentInformation
    }()
    
    override func viewDidLoad() {
        precondition(locationText != nil)
        precondition(linkText != nil)
        precondition(placemark != nil)
        precondition(loggedUser != nil)
        precondition(parseClient != nil)

        mapView.delegate = self
        mapView.register(MKPinAnnotationView.self, forAnnotationViewWithReuseIdentifier: annotationViewId)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let annotation = StudentAnnotation(
            coordinate: placemark.coordinate,
            title: locationText,
            subtitle: linkText,
            studentInformation: studentInformationToPost
        )
        
        mapView.addAnnotation(annotation)
        mapView.centerCoordinate = annotation.coordinate
        
        let region = MKCoordinateRegion(
            center: annotation.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        )
        mapView.setRegion(region, animated: true)
    }
    
    private func makeStudentInformation (
        locationText: String,
        placemark: MKPlacemark,
        linkText: String,
        loggedUser: User) -> StudentInformation {
        
        let student =  StudentInformation(
            firstName: loggedUser.firstName,
            lastName: loggedUser.lastName,
            latitude: placemark.coordinate.latitude,
            longitude: placemark.coordinate.longitude,
            mapTextReference: locationText,
            mediaUrl: URL(string: linkText)!,
            key: loggedUser.key
        )
        
        return student
    }
    
    @objc private func openDefaultBrowser(_ sender: UITapGestureRecognizer?) {
        UIApplication.shared.openDefaultBrowser(accessingAddress: studentInformationToPost.mediaUrl.absoluteString)
    }

    @IBAction func createOrUpdateUsersLocation(_ sender: UIButton) {
        
        let completionHandler: (StudentInformation?, ApiClient.RequestError?) -> Void = { information, error in
            guard error == nil, let information = information else {
                self.displayError(error!, withMessage: "Error sending the student information to the server! Try again later!")
                return
            }
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: NSNotification.Name.StudentInformationCreated,
                    object: self,
                    userInfo: [ParseApiClient.UserInfoKeys.CreatedStudentInformation: information]
                )
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        (studentInformation != nil ? parseClient.updateStudentLocation : parseClient.createStudentLocation)(studentInformationToPost, completionHandler)
    }
}

extension LocationDetailsViewController: MKMapViewDelegate {
    
    // MARK: Map view delegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView: MKPinAnnotationView! =
            mapView.dequeueReusableAnnotationView(
                withIdentifier: annotationViewId,
                for: annotation
            ) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationViewId)
        }
        
        annotationView.displayPriority = .required
        annotationView.pinTintColor = Colors.UserLocationMarkerColor
        annotationView.canShowCallout = true
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        selectedViewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(openDefaultBrowser(_:)))
        view.addGestureRecognizer(selectedViewTapRecognizer!)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.removeGestureRecognizer(selectedViewTapRecognizer!)
    }
}
