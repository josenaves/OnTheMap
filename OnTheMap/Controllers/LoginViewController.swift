//
//  ViewController.swift
//  OnTheMap
//
//  Created by José Naves Moura Neto on 18/02/19.
//  Copyright © 2019 José Naves Moura Neto. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textEmail: UITextField?
    @IBOutlet weak var textPassword: UITextField?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    
    var udacityClient: UdacityApiProtocol!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        precondition(udacityClient != nil, "The API Client must be injected!")

        activityIndicator.isHidden = true
        
        // clear fields (logout)
        textEmail?.text = ""
        textPassword?.text = ""
        
        textEmail?.delegate = self
        textPassword?.delegate = self
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
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
        
        showLoadingState(isLoading: true)
        
        let email = textEmail?.text ?? ""
        let password = textPassword?.text ?? ""
        
        if email.trimmingCharacters(in: .whitespaces).isEmpty {
            showLoadingState(isLoading: false)
            self.presentAlert(withTitle: "Warning", message: "You must enter an email!")
            return
        }
        
        if password.trimmingCharacters(in: .whitespaces).isEmpty {
            showLoadingState(isLoading: false)
            self.presentAlert(withTitle: "Warning", message: "You must enter a password!")
            return
        }

        udacityClient.logIn(withUsername: email, password: password) { account, session, error in
            guard error == nil else {
                self.showLoadingState(isLoading: false)
                self.displayError(error!, withMessage: "The username or password provided isn't correct.")
                return
            }
            
            self.udacityClient.getUserInfo(usingUserIdentifier: account!.key) { user, error in
                guard error == nil else {
                    self.showLoadingState(isLoading: false)
                    self.displayError(error!, withMessage: "Could not get the user details! Plase, try again later.")
                    return
                }
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "initialSegue", sender: self)
                }
            }
        }        
    }
    
    private func showLoadingState(isLoading: Bool) {
        loginButton.isEnabled = !isLoading
        activityIndicator.isHidden = !isLoading
        
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}
