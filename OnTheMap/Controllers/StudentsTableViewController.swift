//
//  TableViewController.swift
//  OnTheMap
//
//  Created by José Naves Moura Neto on 23/02/19.
//  Copyright © 2019 José Naves Moura Neto. All rights reserved.
//

import UIKit

class StudentsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        print("TableViewController - viewDidLoad")
        
        APIClient.sharedInstance().getStudents { (students, errorString) in
            performUIUpdatesOnMain {
                if let students = students {
                    print(students)
                } else {
                    print(errorString as Any)
                }
            }

        }
    }
}
