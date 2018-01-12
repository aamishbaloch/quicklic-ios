//
//  ForgotPasswordViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 1/10/18.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit
import SwiftValidator

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate, ValidationDelegate {

    static let storyboardID = "forgotPasswordViewController"
    
    @IBOutlet weak var countryCodeField: CountryPickerTextField!
    @IBOutlet weak var phoneField: DesignableTextField!
    @IBOutlet weak var confirmationCodeField: DesignableTextField!
    @IBOutlet weak var passwordField: DesignableTextField!
    @IBOutlet weak var confirmPasswordField: DesignableTextField!
    @IBOutlet weak var mainViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var errorLabel: UILabel!
    
    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        validator.registerField(phoneField, errorLabel: errorLabel, rules: [RequiredRule() as Rule,PhoneNumberRule(message: "Invalid Phone Number")])
        validator.registerField(countryCodeField, errorLabel: errorLabel, rules: [RequiredRule() as Rule])
        
//        validator.registerField(passwordField, errorLabel: errorLabel, rules: [RequiredRule() as Rule, MinLengthRule(length: 8) as Rule, MaxLengthRule(length: 20) as Rule])
        
        
        [phoneField,confirmationCodeField,passwordField,confirmPasswordField].forEach { (field) in
            field?.delegate = self
        }
        print( "Login data \(UserDefaults.standard.string(forKey: "userPhone") ?? "")")
        print( "Login data \(UserDefaults.standard.string(forKey: "userPassword") ?? "")")
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func continueButtonPressed(_ sender: Any) {
        validator.validate(self)
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
    
    func validationSuccessful() {
        
        if phoneField.isEnabled == true {
            //forgot pass call
            
            SVProgressHUD.show()
            var params = [String: String]()
            params["phone"] = countryCodeField.text! + phoneField.text!
            RequestManager.forgotPassword(params: params, successBlock: { (response) in
                SVProgressHUD.dismiss()
                
                self.phoneField.isEnabled = false
                self.countryCodeField.isEnabled = false
                self.mainViewHeightConstraint.constant = 280
                self.validator.unregisterField(self.phoneField)
                self.validator.unregisterField(self.countryCodeField)
                self.validator.registerField(self.confirmationCodeField, errorLabel: self.errorLabel, rules: [RequiredRule() as Rule, MinLengthRule(length: 6) as Rule, MaxLengthRule(length: 6) as Rule])
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                })
            }, failureBlock: { (error) in
                SVProgressHUD.showError(withStatus: error)
            })
            
            
        }
        
        else if confirmationCodeField.isEnabled == true {
            //confirm code call
            
            SVProgressHUD.show()
            var params = [String: String]()
            params["phone"] = countryCodeField.text! + phoneField.text!
            params["code"] = confirmationCodeField.text!
            RequestManager.forgotPasswordCodeVerify(params: params, successBlock: { (response) in
                SVProgressHUD.dismiss()
                self.confirmationCodeField.isEnabled = false
                self.mainViewHeightConstraint.constant = 400
                self.validator.unregisterField(self.confirmationCodeField)
                self.validator.registerField(self.passwordField, errorLabel: self.errorLabel, rules: [RequiredRule() as Rule, MinLengthRule(length: 8) as Rule, MaxLengthRule(length: 20) as Rule])
                self.validator.registerField(self.confirmPasswordField, errorLabel: self.errorLabel, rules: [RequiredRule() as Rule, MinLengthRule(length: 8) as Rule, MaxLengthRule(length: 20) as Rule])
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                })
            }, failureBlock: { (error) in
                SVProgressHUD.showError(withStatus: error)
            })
            
            
        }
        
        else if passwordField.isEnabled == true {
            //change password call
            
            SVProgressHUD.show()
            var params = [String: String]()
            params["phone"] = countryCodeField.text! + phoneField.text!
            params["code"] = confirmationCodeField.text!
            params["password"] = passwordField.text!
            RequestManager.forgotPasswordChangePass(params: params, successBlock: { (response) in
                SVProgressHUD.showSuccess(withStatus: "Password changed successfully")
                self.navigationController?.popViewController(animated: true)
            }, failureBlock: { (error) in
                SVProgressHUD.showError(withStatus: error)
            })
            
            
        }
    }
    
}
