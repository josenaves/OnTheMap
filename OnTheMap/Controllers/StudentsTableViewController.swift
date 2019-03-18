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
        if fetchedStudents.count == 0 {
            getStudents { self.tableView?.reloadData() }
        } else {
            self.tableView?.reloadData()
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedStudents.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentDetailsCell", for: indexPath)
        let student = fetchedStudents[indexPath.row]
        
        cell.textLabel?.text = "\(student.lastName), \(student.firstName)"
        cell.detailTextLabel?.text = student.mediaUrl

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentStudent = fetchedStudents[indexPath.row]
        UIApplication.shared.openDefaultBrowser(accessingAddress: currentStudent.mediaUrl)
    }
}
