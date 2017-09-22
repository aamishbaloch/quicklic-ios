//
//  SignUpViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 25/08/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var nameField: DesignableTextField!
    @IBOutlet weak var emailField: DesignableTextField!
    @IBOutlet weak var phoneField: DesignableTextField!
    @IBOutlet weak var dobField: DatePickerTextField!
    @IBOutlet weak var genderSegmentControl: UISegmentedControl!
    @IBOutlet weak var passwordField: DesignableTextField!
    @IBOutlet weak var confirmPasswordField: DesignableTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        /*
         {
         "email": "patient03@gmail.com",
         "first_name": "patient03",
         "last_name": "user",
         "password": "arbisoft",
         "gender": "M",
         "phone": "23423324234",
         "dob": "2017-08-08"
         }*/
        var params = [String: String]()
        params["email"] = emailField.text
        let names = nameField.text?.components(separatedBy: " ")
        params["first_name"] = names?.first
        params["last_name"] = names?.last
        params["password"] = passwordField.text
        switch genderSegmentControl.selectedSegmentIndex {
        case 0:
            params["gender"] = "M"
        case 1:
            params["gender"] = "F"
        case 2:
            params["gender"] = "U"
        default:
            break
        }
        params["phone"] = phoneField.text
        params["dob"] = UtilityManager.serverDateStringFromAppDateString(date: dobField.text!)
        
        RequestManager.signUpUser(param: params, successBlock: { (response: [String : AnyObject]) in
            if response["role"] as! String == "PAT" {
                ApplicationManager.sharedInstance.userType = .Patient
            }
            else{
                ApplicationManager.sharedInstance.userType = .Doctor
            }
            Router.sharedInstance.showDashboardAsRoot()
        }) { (error) in
            print(error)
        }
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
