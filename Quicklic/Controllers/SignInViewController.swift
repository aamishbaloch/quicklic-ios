//
//  SignInViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 25/08/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit
import SwiftValidator

class SignInViewController: UIViewController, ValidationDelegate, UITextFieldDelegate {

    @IBOutlet weak var emailField: DesignableTextField!
    @IBOutlet weak var passwordField: DesignableTextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        validator.registerField(emailField, errorLabel: errorLabel, rules: [RequiredRule() as Rule,PhoneNumberRule(message: "Invalid Phone Number")])
        validator.registerField(passwordField, errorLabel: errorLabel, rules: [RequiredRule() as Rule, MinLengthRule(length: 8) as Rule, MaxLengthRule(length: 20) as Rule])
        
        [emailField,passwordField].forEach { (field) in
            field?.delegate = self
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signinButtonPressed(_ sender: Any) {
        
        validator.validate(self)
        
    }
    
    @IBAction func touchIDPressed(_ sender: Any) {
        
    }
    
    func validationSuccessful() {
        var params = [String: String]()
        params["phone"] = emailField.text
        params["password"] = passwordField.text
        SVProgressHUD.show(withStatus: "Signing In")
        RequestManager.loginUser(param: params, successBlock: { (response: [String : AnyObject]) in
            SVProgressHUD.dismiss()
            UserDefaults.standard.set(response["token"] as! String, forKey: "token")
            if response["role"] as! Int == Role.Patient.rawValue {
                ApplicationManager.sharedInstance.userType = .Patient
            }
            else{
                ApplicationManager.sharedInstance.userType = .Doctor
            }
            if response["verified"] as! Bool == true {
                Router.sharedInstance.showDashboardAsRoot()
            }
            else{
                Router.sharedInstance.showVerification(fromController: self)
            }
            
        }) { (error) in
            SVProgressHUD.dismiss()
            print(error)
        }
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for (field, error) in errors {
            if let field = field as? UITextField {
                field.layer.borderColor = UIColor.red.cgColor
                field.layer.borderWidth = 1.0
                if error.errorLabel?.isHidden == true {
                    error.errorLabel?.text = error.errorMessage // works if you added labels
                    error.errorLabel?.isHidden = false
                }
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor(red: 175.0/255.0, green: 179.0/255.0, blue: 182.0/255.0, alpha: 1.0).cgColor
        errorLabel.isHidden = true
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
