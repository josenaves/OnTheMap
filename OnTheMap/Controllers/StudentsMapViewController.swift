//
//  MapViewController.swift
//  OnTheMap
//
//  Created by José Naves Moura Neto on 23/02/19.
//  Copyright © 2019 José Naves Moura Neto. All rights reserved.
//

import UIKit
import MapKit

class StudentsMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    /// The reuse identifier of the annotation views used on the map.
    let annotationReuseID = "annotationReuseID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.setUserTrackingMode(.followWithHeading, animated: true)
        mapView.showsUserLocation = true
        
        if fetchedStudents.count == 0 {
            getStudents { self.displayStudentLocations() }
        } else {
            self.displayStudentLocations()
        }
    }
        
    func displayStudentLocations() {
        mapView.removeAnnotations(mapView.annotations)
        
        mapView.addAnnotations(fetchedStudents.compactMap {
            StudentAnnotation(
                coordinate: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude),
                title: "\($0.lastName), \($0.firstName)",
                subtitle: $0.mediaUrl,
                studentInformation: $0
            )
        })
    }
    
    /// Displays the link found in the selected annotation.
    @objc private func displayPostedLink(_ sender: AnnotationTapRecognizer?) {
        guard let urlText = sender?.link else {
            assertionFailure("The link of the tap recognizer must be set.")
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

        annotationView.pinTintColor = .red
        
        annotationView.canShowCallout = true
        annotationView.displayPriority = .required
        
        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if let recognizer = view.gestureRecognizers?.filter({ $0 is AnnotationTapRecognizer }).first {
            view.removeGestureRecognizer(recognizer)
        }
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
}
