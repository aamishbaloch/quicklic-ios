//
//  EditProfileViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 29/08/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, MLPAutoCompleteTextFieldDelegate, MLPAutoCompleteTextFieldDataSource {

    static let storyboardID = "editProfileViewController"
    
    @IBOutlet weak var nameField: DesignableTextField!
    @IBOutlet weak var emailField: DesignableTextField!
    @IBOutlet weak var addressField: DesignableTextField!
    @IBOutlet weak var profileImageView: DZImageView!
    @IBOutlet weak var cityField: MLPAutoCompleteTextField!
    @IBOutlet weak var countryField: MLPAutoCompleteTextField!
    @IBOutlet weak var heightField: DesignableTextField!
    @IBOutlet weak var weightField: DesignableTextField!
    @IBOutlet weak var maritalStatusControl: UISegmentedControl!
    @IBOutlet weak var occupationField: MLPAutoCompleteTextField!
    @IBOutlet weak var serviceField: MLPAutoCompleteTextField!
    @IBOutlet weak var specializationField: MLPAutoCompleteTextField!
    @IBOutlet weak var degreeField: DesignableTextField!
    @IBOutlet weak var doctorView: UIView!
    @IBOutlet weak var doctorSubmitConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Edit Profile"
        
        cityField.autoCompleteDelegate = self
        cityField.autoCompleteDataSource = self
        
        countryField.autoCompleteDelegate = self
        countryField.autoCompleteDataSource = self
        
        occupationField.autoCompleteDelegate = self
        occupationField.autoCompleteDataSource = self
        
        profileImageView.parentController = self
        // Do any additional setup after loading the view.
        
        if ApplicationManager.sharedInstance.userType == .Doctor {
            doctorView.isHidden = false
            doctorSubmitConstraint.constant = -30
            serviceField.autoCompleteDelegate = self
            serviceField.autoCompleteDataSource = self
            specializationField.autoCompleteDelegate = self
            specializationField.autoCompleteDataSource = self
        }
        else{
            doctorView.isHidden = true
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        
        self.presentLeftMenuViewController(nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        var params = [String: AnyObject]()
        
        let names = nameField.text?.components(separatedBy: " ")
        params["first_name"] = names?.first as AnyObject
        params["last_name"] = names?.last as AnyObject
        params["address"] = addressField.text as AnyObject
        params["city"] = cityField.text as AnyObject
        params["country"] = countryField.text as AnyObject
        if ApplicationManager.sharedInstance.userType == .Patient {
            params["height"] = heightField.text as AnyObject
            params["weight"] = weightField.text as AnyObject
            params["occupation"] = occupationField.text as AnyObject
        }
        else{
            params["specialization"] = specializationField.text as AnyObject
            params["services"] = [serviceField.text] as AnyObject
            params["degree"] = degreeField.text as AnyObject
        }
        
        SVProgressHUD.show(withStatus: "Updating Profile")
        RequestManager.editUser(param: params, image: profileImageView.image, successBlock: { (response) in
            SVProgressHUD.showSuccess(withStatus: "Updated")
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
        }
        
    }
    
    func autoCompleteTextField(_ textField: MLPAutoCompleteTextField!, possibleCompletionsFor string: String!, completionHandler handler: (([Any]?) -> Void)!) {
        if textField == cityField{
            RequestManager.getCities(query: string,successBlock: { (response) in
                var array = [String]()
                for city in response {
                    array.append(city["name"] as! String)
                }
                handler(array)
            }) { (error) in
                SVProgressHUD.showError(withStatus: error)
            }
        }
        else if textField == countryField {
            RequestManager.getCountries(query: string,successBlock: { (response) in
                var array = [String]()
                for city in response {
                    
                    array.append(city["name"] as! String)
                }
                handler(array)
            }) { (error) in
                SVProgressHUD.showError(withStatus: error)
            }
        }
        else if textField == occupationField {
            RequestManager.getOccupations(query: string,successBlock: { (response) in
                var array = [String]()
                for city in response {
                    
                    array.append(city["name"] as! String)
                }
                handler(array)
            }) { (error) in
                SVProgressHUD.showError(withStatus: error)
            }
        }
        else if textField == serviceField {
            RequestManager.getServices(query: string,successBlock: { (response) in
                var array = [String]()
                for city in response {
                    
                    array.append(city["name"] as! String)
                }
                handler(array)
            }) { (error) in
                SVProgressHUD.showError(withStatus: error)
            }
        }
        else if textField == specializationField {
            RequestManager.getSpecializations(query: string,successBlock: { (response) in
                var array = [String]()
                for city in response {
                    
                    array.append(city["name"] as! String)
                }
                handler(array)
            }) { (error) in
                SVProgressHUD.showError(withStatus: error)
            }
        }
    }
    
//    func autoCompleteTextField(_ textField: MLPAutoCompleteTextField!, possibleCompletionsFor string: String!) -> [Any]! {
//        if textField == cityField{
//            return cities
//        }
//        else if textField == countryField {
//            return countries
//        }
//        else if textField == occupationLabel {
//            return occupation
//        }
//        else { return [""] }
//    }
    
    func autoCompleteTextField(_ textField: MLPAutoCompleteTextField!, didSelectAutoComplete selectedString: String!, withAutoComplete selectedObject: MLPAutoCompletionObject!, forRowAt indexPath: IndexPath!) {
        
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
