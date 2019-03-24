//
//  MapViewController.swift
//  OnTheMap
//
//  Created by José Naves Moura Neto on 23/02/19.
//  Copyright © 2019 José Naves Moura Neto. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class StudentsMapViewController: UIViewController {
    
    var parseClient: ParseApiProtocol!
    var loggedUser: User!
    
    /// The reuse identifier of the annotation views used on the map.
    let annotationReuseID = "annotationReuseID"

    @IBOutlet weak var tabMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        precondition(parseClient != nil)
        precondition(loggedUser != nil)
        
        tabMapView.delegate = self
        tabMapView.showsUserLocation = true
        tabMapView.setUserTrackingMode(.followWithHeading, animated: true)
        
        displayStudentLocations()
    }
    
    func displayStudentLocations() {
        tabMapView.removeAnnotations(tabMapView.annotations)
        tabMapView.addAnnotations(parseClient.studentLocations.compactMap {
            StudentAnnotation(
                coordinate: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude),
                title: "\($0.lastName), \($0.firstName)",
                subtitle: $0.mediaUrl.absoluteString,
                studentInformation: $0
            )
        })
    }

    @objc private func displayPostedLink(_ sender: AnnotationTapRecognizer?) {
        guard let urlText = sender?.link else {
            assertionFailure("The link of the tap recognizer must be set!!!")
            return
        }
        UIApplication.shared.openDefaultBrowser(accessingAddress: urlText)
    }
}

extension StudentsMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let studentAnnotation = annotation as? StudentAnnotation else {
            return nil
        }
        
        var annotationView: MKPinAnnotationView! =
            mapView.dequeueReusableAnnotationView(withIdentifier: annotationReuseID) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(
                annotation: studentAnnotation,
                reuseIdentifier: annotationReuseID
            )
        }
        
        if studentAnnotation.studentInformation.key == loggedUser.key {
            annotationView.pinTintColor = Colors.UserLocationMarkerColor
        } else {
            annotationView.pinTintColor = .red
        }
        
        annotationView.canShowCallout = true
        annotationView.displayPriority = .required
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let studentAnnotation = view.annotation as? StudentAnnotation else {
            return
        }
        
        guard let link = studentAnnotation.subtitle else {
            assertionFailure("The annotation must have a valid link.")
            return
        }
        
        let tapRecognizer = AnnotationTapRecognizer(
            target: self,
            action: #selector(displayPostedLink(_:)),
            link: link
        )
        view.addGestureRecognizer(tapRecognizer)
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if let recognizer = view.gestureRecognizers?.filter({ $0 is AnnotationTapRecognizer }).first {
            view.removeGestureRecognizer(recognizer)
        }
    }
    
}
