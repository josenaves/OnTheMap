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
        tableView.rowHeight = 88
        if fetchedStudents.count == 0 {
            getStudents { self.tableView?.reloadData() }
        } else {
            self.tableView?.reloadData()
        }
    }
    
    @IBAction func refreshData(_ sender: Any) {
        getStudents { self.tableView?.reloadData() }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedStudents.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentDetailsCell", for: indexPath) as! StudentCell
        let student = fetchedStudents[indexPath.row]
        
        cell.nameLabel?.text = "\(student.lastName), \(student.firstName)"
        cell.urlLabel?.text = student.mediaUrl

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentStudent = fetchedStudents[indexPath.row]
        UIApplication.shared.openDefaultBrowser(accessingAddress: currentStudent.mediaUrl)
    }
}
