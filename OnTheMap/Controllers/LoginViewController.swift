//
//  ViewController.swift
//  OnTheMap
//
//  Created by José Naves Moura Neto on 18/02/19.
//  Copyright © 2019 José Naves Moura Neto. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var textEmail: UITextField?
    @IBOutlet weak var textPassword: UITextField?
    
    var udacityClient: UdacityApiProtocol!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        precondition(udacityClient != nil, "The API Client must be injected!")

        // clear fields (logout)
        textEmail?.text = ""
        textPassword?.text = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "initialSegue" {
            if let navigationController = segue.destination as? UINavigationController,
               let tabController = navigationController.visibleViewController as? StudentsTabBarController {
                tabController.udacityClient = self.udacityClient
                tabController.parseClient = ParseApiClient()
                tabController.loggedUser = udacityClient.user
            }
        }
    }

    @IBAction func navigateToSignup(sender: UIButton) {
        if let link = URL(string: "https://www.udacity.com/account/auth#!/signup") {
            UIApplication.shared.open(link)
        }
    }
    
    @IBAction func authenticate(sender: UIButton) {
        
        let email = textEmail?.text ?? ""
        let password = textPassword?.text ?? ""
        
        if email.trimmingCharacters(in: .whitespaces).isEmpty {
            self.presentAlert(withTitle: "Warning", message: "You must enter an email!")
            return
        }
        
        if password.trimmingCharacters(in: .whitespaces).isEmpty {
            self.presentAlert(withTitle: "Warning", message: "You must enter a password!")
            return
        }

        
        udacityClient.logIn(withUsername: email, password: password) { account, session, error in
            guard error == nil else {
                self.displayError(error!, withMessage: "The username or password provided isn't correct.")
                return
            }
            
            self.udacityClient.getUserInfo(usingUserIdentifier: account!.key) { user, error in
                guard error == nil else {
                    self.displayError(error!, withMessage: "Could not get the user details! Plase, try again later.")
                    return
                }
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "initialSegue", sender: self)
                }
            }
        }        
    }
}
