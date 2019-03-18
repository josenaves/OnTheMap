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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // clear fields (logout)
        textEmail?.text = ""
        textPassword?.text = ""
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

        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            
            if error != nil {
                DispatchQueue.main.async(execute: {
                    self.presentAlert(withTitle: "Error", message: "There was a problema with your connection! Please check it!")
                })
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if (httpResponse.statusCode != 200) {
                    
                    DispatchQueue.main.async(execute: {
                        self.presentAlert(withTitle: "Warning", message: "Wrong credentials! Please check your email or password!")
                    })
                    return
                }
            }

//            let range = 5..<data!.count
//            let newData = data?.subdata(in: range) /* subset response data! */
            
            DispatchQueue.main.async(execute: {
                self.presentAlert(withTitle: "Success", message: "Successfully logged in", completion: {
                    self.performSegue(withIdentifier: "initialSegue", sender: self)
                })
            })
        }
        task.resume()
        
    }
}
