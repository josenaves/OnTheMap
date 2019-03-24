//
//  StudentsTabBarController.swift
//  OnTheMap
//
//  Created by José Naves Moura Neto on 17/03/19.
//  Copyright © 2019 José Naves Moura Neto. All rights reserved.
//

import UIKit
import CoreLocation

class StudentsTabBarController: UITabBarController {
    
    var udacityClient: UdacityApiProtocol!
    var parseClient: ParseApiProtocol!
    
    var loggedUser: User!
    
    var studentInformation: StudentInformation?
    
    var locationManager: CLLocationManager!
    
    deinit {
        unsubscribeFromAllNotifications()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        precondition(udacityClient != nil)
        precondition(parseClient != nil)
        precondition(loggedUser != nil)
        
        locationManager = CLLocationManager()
        
        guard let tableViewController = viewControllers!.first as? StudentsTableViewController,
            let mapViewController = viewControllers!.last as? StudentsMapViewController else {
            preconditionFailure("Could not get the child view controllers!")
        }
        
        tableViewController.loggedUser = loggedUser
        tableViewController.parseClient = parseClient
        
        mapViewController.loggedUser = loggedUser
        mapViewController.parseClient = parseClient
        
        delegate = self

        subscribeToNotification(
            named: Notification.Name.StudentInformationCreated,
            usingSelector: #selector(displayCreatedLocation(usingNotification:))
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        refreshData()
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    // loadLocations
    @IBAction func refreshData(_ sender: UIBarButtonItem? = nil) {
        
        // disable refresh button for a while
        sender?.isEnabled = false

        func showFetchedLocationsOnMainThread(_ locations: [StudentInformation]) {
            DispatchQueue.main.async {
                sender?.isEnabled = true
                self.displayStudentLocations(locations)
            }
        }
        
        parseClient.fetchStudentLocations(withLimit: 100, skippingPages: 0) { locations, error in
            let errorMessage = """
                There was an error downloading the students' locations! Please, contact the app developer for more information.
            """
            
            guard let locations = locations, error == nil else {
                self.displayError(error ?? .malformedJson, withMessage: errorMessage)
                DispatchQueue.main.async { sender?.isEnabled = true }
                return
            }
            
            if self.studentInformation == nil {
                // Search for the student information of the logged user.Z
                if let loggedUserInformation = locations.filter({ $0.key == self.loggedUser.key }).first {
                    
                    self.studentInformation = loggedUserInformation
                    showFetchedLocationsOnMainThread(locations)
                    
                } else {

                    _ = self.parseClient.fetchStudentLocation(byUsingUniqueKey: self.loggedUser.key) { information, _ in
                        
                        if let information = information {
                            self.studentInformation = information
                            self.parseClient.studentLocations.append(information)
                            self.parseClient.sortLocations()
                        }
                        
                        showFetchedLocationsOnMainThread(self.parseClient.studentLocations)
                    }
                }
            } else {
                showFetchedLocationsOnMainThread(locations)
            }
        }
    }
    
    private func displayStudentLocations(_ locations: [StudentInformation]) {
        
        guard let tableViewController = viewControllers?.first as? StudentsTableViewController,
            let mapViewController = viewControllers?.last as? StudentsMapViewController else {
                assertionFailure("Could not get the child view controllers!")
                return
        }
        
        if mapViewController.tabMapView != nil {
            print("map is valid!")
            mapViewController.displayStudentLocations()
        } else {
            print("map is invalid!!!!!!")
        }
        tableViewController.displayStudentLocations()
    }

    @objc private func displayCreatedLocation(usingNotification notification: NSNotification) {
        guard let createdInformation =
            notification.userInfo?[ParseApiClient.UserInfoKeys.CreatedStudentInformation] as? StudentInformation else {
                preconditionFailure("Could not get created student information from the notification!")
        }
        
        studentInformation = createdInformation
        
        parseClient.studentLocations.removeAll {
            $0.key == createdInformation.key && $0.objectID == createdInformation.objectID
        }
        parseClient.studentLocations.append(createdInformation)
        parseClient.sortLocations()
        
        displayStudentLocations(parseClient.studentLocations)
    }

    @IBAction func logout(_ sender: UIBarButtonItem) {
        
        sender.isEnabled = false
        
        udacityClient.logOut { isSuccessful, error in
            guard isSuccessful, error == nil else {
                self.displayError(error!, withMessage: "There was an error while logging out. Please, try again later!")
                DispatchQueue.main.async {
                    sender.isEnabled = true
                }
                return
            }
            
            DispatchQueue.main.async {
                self.dismiss(animated: true)
                sender.isEnabled = true
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addLocationSegue" {
            if let addLocationController = segue.destination as? AddLocationViewController {
                addLocationController.loggedUser = loggedUser
                addLocationController.parseClient = parseClient
                addLocationController.studentInformation = studentInformation
                
                if let mapController = viewControllers?.last as? StudentsMapViewController {
                    if let map = mapController.tabMapView {
                        addLocationController.userLocation = map.userLocation
                    } else {
                        print("tabMapView is nil")
                    }
                }
            }
        }
    }

}

extension StudentsTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        title = viewController.title
    }
}
