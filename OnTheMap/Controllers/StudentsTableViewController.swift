//
//  TableViewController.swift
//  OnTheMap
//
//  Created by José Naves Moura Neto on 23/02/19.
//  Copyright © 2019 José Naves Moura Neto. All rights reserved.
//

import UIKit

class StudentsTableViewController: UITableViewController {
    
    var fetchedStudents = [StudentInformation]()
    
    override func viewDidLoad() {
        print("TableViewController - viewDidLoad")
        
        tableView.register(StudentCell.self, forCellReuseIdentifier: "StudentDetailsCell")

        APIClient.sharedInstance().getStudents { (students, errorString) in
            performUIUpdatesOnMain {
                if let students = students {
                    print(students)
                    // TODO put it all on the tableview
                    self.fetchedStudents.append(contentsOf: students)
                } else {
                    print(errorString as Any)
                    
                    // TODO display an error to the user
                }
            }

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView?.reloadData()
    }
    
    // MARK: - Table view data source
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedStudents.count
    }

//    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentDetailsCell", for: indexPath) as! StudentCell
        let student = fetchedStudents[indexPath.row]
        print(student)
        
        if let firstName = student.firstName, let lastName = student.lastName {
            cell.nameLabel?.text = "\(lastName), \(firstName)"
        } else {
            cell.nameLabel?.text = "Unknown student"
        }
        
        if let url = student.mediaUrl {
            cell.urlLabel?.text = url
        } else {
            cell.urlLabel?.text = "-"
        }
        
        return cell
    }
}
