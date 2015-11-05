//
//  LoginSignupPickerViewController.swift
//  Timeline
//
//  Created by James Pacheco on 11/3/15.
//  Copyright © 2015 James Pacheco. All rights reserved.
//

import UIKit

class LoginSignupPickerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? LoginSignupViewController {
            guard let identifier = segue.identifier else {return}
            switch identifier {
            case "loginSegue":
                destination.mode = .Login
            case "signupSegue":
                destination.mode = .Signup
            default:
                break
            }
        }
    }


}
