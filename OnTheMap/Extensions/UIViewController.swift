//
//  UIViewController.swift
//  OnTheMap
//
//  Created by José Naves Moura Neto on 16/03/19.
//  Copyright © 2019 José Naves Moura Neto. All rights reserved.
//

import UIKit

extension UIViewController {
    
    enum Colors {
        static let UserLocationCellColor = #colorLiteral(red: 0.8105276351, green: 1, blue: 0.6708432227, alpha: 1)
        static let UserLocationMarkerColor = UIColor.green
    }

    func presentAlert(withTitle title: String, message : String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
            if let completion = completion {
                completion()
            }
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func displayError(_ error: ApiClient.RequestError, withMessage message: String) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            
            var alertMessage: String?
            
            switch error {
            case .connection:
                alertMessage = "There's a problem with your internet connection, please, fix it and try again."
            case .response(_):
                alertMessage = message
            default:
                break
            }
            
            alert.message = alertMessage
            self.present(alert, animated: true)
        }
    }
    
    func subscribeToNotification(named name: Notification.Name, usingSelector selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}
