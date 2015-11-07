//
//  LoginSignupViewController.swift
//  Timeline
//
//  Created by James Pacheco on 11/3/15.
//  Copyright © 2015 James Pacheco. All rights reserved.
//

import UIKit

class LoginSignupViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var bioField: UITextField!
    
    @IBOutlet weak var urlField: UITextField!

    @IBOutlet weak var actionButton: UIButton!
    
    enum ViewMode {
        case Login
        case Signup
        case Edit
    }
    
    var mode = ViewMode.Signup
    
    var user: User?
    
    var fieldsAreValid: Bool {
        switch mode {
        case .Signup:
            guard let username = usernameField.text where username.characters.count>4, let email = emailField.text where email.characters.count>0, let password = passwordField.text where password.characters.count>4 else {return false}
            return true
        case .Login:
            guard let email = emailField.text where email.characters.count>0, let password = passwordField.text where password.characters.count>4 else {return false}
            return true
        case .Edit:
            guard let username = usernameField.text where username.characters.count>4 else {return false}
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViewForMode(mode)
    }
    
    func updateViewForMode(mode: ViewMode) {
        switch mode {
        case .Signup:
            actionButton.setTitle("Signup", forState: .Normal)
        case .Login:
            actionButton.setTitle("Login", forState: .Normal)
            usernameField.hidden = true
            bioField.hidden = true
            urlField.hidden = true
        case .Edit:
            actionButton.setTitle("Save Changes", forState: .Normal)
            emailField.hidden = true
            passwordField.hidden = true
        }
    }

    @IBAction func actionButtonTapped(sender: AnyObject) {
        
        if fieldsAreValid {
            switch self.mode {
            case .Signup:
                guard let email = emailField.text, username = usernameField.text, password = passwordField.text else {break}
                UserController.createUser(email, username: username, password: password, bio: bioField.text, url: urlField.text, completion: { (success, user) -> Void in
                    if success {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        self.presentValidationAlertWithTitle("Unable to create user", text: "Please ensure that you have a valid username, email, and password")
                    }
                })
            case.Login:
                guard let email = emailField.text, password = passwordField.text else {break}
                UserController.authenticateUser(email, password: password, completion: { (success, user) -> Void in
                    if success {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        self.presentValidationAlertWithTitle("Invalid credentials", text: "We don't recognize the email and password combination that you gave us.")
                    }
                })
            case .Edit:
                guard let username = usernameField.text else {break}
                UserController.updateUser(UserController.sharedController.currentUser, username: username, bio: bioField.text, url: urlField.text, completion: { (success, user) -> Void in
                    if success {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        self.presentValidationAlertWithTitle("Unable to update information", text: "Please input a valid username")
                    }
                })
            }
        } else {
            self.presentValidationAlertWithTitle("Missing Information", text: "Please check that you have valid entries in all required fields and try again")
        }
    }
    
    func presentValidationAlertWithTitle(title: String, text: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func updateWithUser() {
        self.user = UserController.sharedController.currentUser
        mode = .Edit
    }
}

