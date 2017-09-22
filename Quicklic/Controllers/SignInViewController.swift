//
//  SignInViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 25/08/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var emailField: DesignableTextField!
    @IBOutlet weak var passwordField: DesignableTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func signinButtonPressed(_ sender: Any) {
        
        var params = [String: String]()
        params["email"] = emailField.text
        params["password"] = passwordField.text
        
        RequestManager.loginUser(param: params, successBlock: { (response: [String : AnyObject]) in
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
    
    @IBAction func touchIDPressed(_ sender: Any) {
        
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
