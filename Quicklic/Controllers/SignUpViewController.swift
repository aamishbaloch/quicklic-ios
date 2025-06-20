//
//  SignUpViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 25/08/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit
import SwiftValidator

class SignUpViewController: UIViewController, ValidationDelegate, UITextFieldDelegate {

    @IBOutlet weak var nameField: DesignableTextField!
    @IBOutlet weak var phoneField: DesignableTextField!
    @IBOutlet weak var phoneCodeField: CountryPickerTextField!
    @IBOutlet weak var dobField: DatePickerTextField!
    @IBOutlet weak var genderSegmentControl: UISegmentedControl!
    @IBOutlet weak var passwordField: DesignableTextField!
    @IBOutlet weak var confirmPasswordField: DesignableTextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        validator.registerField(nameField, errorLabel: errorLabel, rules: [RequiredRule() as Rule,FullNameRule() as Rule])
        validator.registerField(passwordField, errorLabel: errorLabel, rules: [RequiredRule() as Rule, MinLengthRule(length: 8) as Rule, MaxLengthRule(length: 20) as Rule])
        validator.registerField(confirmPasswordField, errorLabel: errorLabel, rules: [ConfirmationRule(confirmField: passwordField)])
        validator.registerField(phoneField, errorLabel: errorLabel, rules: [RequiredRule() as Rule,PhoneNumberRule(message: "Invalid Phone Number")])
        validator.registerField(phoneCodeField, errorLabel: errorLabel, rules: [RequiredRule() as Rule])
        
        [nameField,passwordField,confirmPasswordField,phoneField].forEach { (field) in
            field?.delegate = self
        }
    
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        validator.validate(self)
    }
    
    func validationSuccessful() {
        
        var params = [String: String]()
        let names = nameField.text?.components(separatedBy: " ")
        params["first_name"] = names?.first
        params["last_name"] = names?.last
        params["password"] = passwordField.text
        params["gender"] = "\(genderSegmentControl.selectedSegmentIndex+1)"
        params["phone"] = phoneCodeField.text! + phoneField.text!
        params["dob"] = UtilityManager.serverDateStringFromAppDateString(date: dobField.text!)
        if let deviceID = UserDefaults.standard.value(forKey: "pushNotificationToken") as? String {
            params["device_id"] = deviceID
            params["device_type"] = "0"
        }
        SVProgressHUD.show()
        RequestManager.signUpUser(param: params, successBlock: { (response: [String : AnyObject]) in
            
            let user = User(dictionary: response)
            ApplicationManager.sharedInstance.user = user
            UserDefaults.standard.set(response["token"] as! String, forKey: "token")
            UserDefaults.standard.set(user.phone, forKey: "userPhone")
            UserDefaults.standard.set(self.passwordField.text, forKey: "userPassword")
            UserDefaults.standard.set(true, forKey: "loggedIn") 
            if response["role"] as! Int == Role.Patient.rawValue {
                ApplicationManager.sharedInstance.userType = .Patient
            }
            else{
                ApplicationManager.sharedInstance.userType = .Doctor
            }
            
            SVProgressHUD.dismiss()
            Router.sharedInstance.showVerification(fromController: self)
        
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
