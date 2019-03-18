//
//  StudentsTabBarController.swift
//  OnTheMap
//
//  Created by José Naves Moura Neto on 17/03/19.
//  Copyright © 2019 José Naves Moura Neto. All rights reserved.
//

import UIKit

class StudentsTabBarController: UITabBarController {
    
    @IBAction func refreshData(_ sender: Any) {
        let tab = self.tabBar.selectedItem?.tag
        if tab == 0 {
            // tableview
            let tableVC = self.selectedViewController as! StudentsTableViewController
            getStudents { tableVC.tableView?.reloadData() }
        } else {
            // map
            let mapVC = self.selectedViewController as! StudentsMapViewController
            getStudents { mapVC.displayStudentLocations() }
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        doLogout()
    }
}
