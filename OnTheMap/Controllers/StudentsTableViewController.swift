//
//  TableViewController.swift
//  OnTheMap
//
//  Created by José Naves Moura Neto on 23/02/19.
//  Copyright © 2019 José Naves Moura Neto. All rights reserved.
//

import UIKit

class StudentsTableViewController: UITableViewController {
    
    var loggedUser: User!
    var parseClient: ParseApiProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        precondition(parseClient != nil)
        precondition(loggedUser != nil)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parseClient.studentLocations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentDetailsCell", for: indexPath)
        
        let studentLocation = parseClient.studentLocations[indexPath.row]

        if studentLocation.key == loggedUser.key {
            cell.backgroundColor = Colors.UserLocationCellColor
        } else {
            cell.backgroundColor = .white
        }

        cell.textLabel?.text = "\(studentLocation.lastName), \(studentLocation.firstName)"
        cell.detailTextLabel?.text = studentLocation.mediaUrl.absoluteString

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentStudent = parseClient.studentLocations[indexPath.row]
        UIApplication.shared.openDefaultBrowser(accessingAddress: currentStudent.mediaUrl.absoluteString)
    }
    
    func displayStudentLocations() {
        tableView.reloadData()
    }

}
