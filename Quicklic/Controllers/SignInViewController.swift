//
//  SignInViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 25/08/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit
import SwiftValidator
import LocalAuthentication


class SignInViewController: UIViewController, ValidationDelegate, UITextFieldDelegate {

    @IBOutlet weak var emailField: DesignableTextField!
    @IBOutlet weak var passwordField: DesignableTextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var countryCodeField: CountryPickerTextField!
    
    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        validator.registerField(emailField, errorLabel: errorLabel, rules: [RequiredRule() as Rule,PhoneNumberRule(message: "Invalid Phone Number")])
        validator.registerField(passwordField, errorLabel: errorLabel, rules: [RequiredRule() as Rule, MinLengthRule(length: 8) as Rule, MaxLengthRule(length: 20) as Rule])
        validator.registerField(countryCodeField, errorLabel: errorLabel, rules: [RequiredRule() as Rule])
        
        [emailField,passwordField].forEach { (field) in
            field?.delegate = self
        }
         print( "Login data \(UserDefaults.standard.string(forKey: "userPhone") ?? "")")
         print( "Login data \(UserDefaults.standard.string(forKey: "userPassword") ?? "")")
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
      
    }

    func dismissKeyboard() {
       
        view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signinButtonPressed(_ sender: Any) {
        
        validator.validate(self)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    @IBAction func touchIDPressed(_ sender: Any) {
        authenticateUser()
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        Router.sharedInstance.showForgotPassword(fromController: self)
    }
    
    func authenticateUser() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                      
                     let phone = UserDefaults.standard.string(forKey: "userPhone")
                     let pass = UserDefaults.standard.string(forKey: "userPassword")
                        
                        if (phone != nil && pass != nil)
                        {
                            var params = [String: String]()
                            params["phone"] = phone
                            params["password"] = pass
                            
                            self.signinUser(params: params)
//                            Router.sharedInstance.showDashboardAsRoot()
                        }else{
                            
                            SVProgressHUD.showError(withStatus: "Please signin with your credentials to use touch id")
                            
                        }
    
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "Sorry!", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Touch ID not available", message: "Your device is not configured for Touch ID.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
   
    
    func validationSuccessful() {
        var params = [String: String]()
        params["phone"] = countryCodeField.text! + emailField.text!
        params["password"] = passwordField.text
        signinUser(params: params)
    }
    
    func signinUser(params: [String: String]) {
        
        var params = params
        
        if let deviceID = UserDefaults.standard.value(forKey: "pushNotificationToken") as? String{
            params["device_id"] = deviceID
            params["device_type"] = "0"
        }
        
        SVProgressHUD.show(withStatus: "Signing In")
        RequestManager.loginUser(param: params, successBlock: { (response: [String : AnyObject]) in
            SVProgressHUD.dismiss()
            
            let user = User(dictionary: response)
            ApplicationManager.sharedInstance.user = user
            
            UserDefaults.standard.set(response["token"] as! String, forKey: "token")
            if let pass = self.passwordField.text {
                if pass.count >= 0 {
                    UserDefaults.standard.set(user.phone, forKey: "userPhone")
                    UserDefaults.standard.set(pass, forKey: "userPassword")
                }
            }
            
            UserDefaults.standard.set(true, forKey: "loggedIn")
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
            SVProgressHUD.showError(withStatus: error)
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
