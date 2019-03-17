//
//  UIViewController+Extensions.swift
//  OnTheMap
//
//  Created by José Naves Moura Neto on 16/03/19.
//  Copyright © 2019 José Naves Moura Neto. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var fetchedStudents: [StudentInformation] {
        get {
            return Model.shared.students
        }
        set(students) {
            Model.shared.students = students
        }
    }
    
    func getStudents(_ completionCallback: (() -> Void)? = nil ) {
        APIClient.sharedInstance().getStudents { (students, errorString) in
            performUIUpdatesOnMain {
                if let students = students {
                    
                    Model.shared.students.removeAll()
                    Model.shared.students.append(contentsOf: students)
                    
                    // sort students by updatedAt
                    Model.shared.students = Model.shared.students.sorted(by: { $0.updatedAt > $1.updatedAt })
                    
                    // call the callback
                    completionCallback?()
                    
                } else {
                    let error = errorString?.localizedDescription ?? "Generic error"
                    self.presentAlert(withTitle: "Error", message: error)
                }
            }
        }
    }
    
    func doLogout() {
        logout { error in
            let message = error == nil ? "Successfully logged out" : "Error logging out"
            self.presentAlert(withTitle: "Success", message: message, completion: { self.dismiss(animated: true) })
        }
    }
    
    private func logout(_ callback: @escaping ((_ error: Error?) -> Void)) {
        APIClient.sharedInstance().logout(callback)
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
}
