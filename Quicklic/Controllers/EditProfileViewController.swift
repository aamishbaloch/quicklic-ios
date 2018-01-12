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
    @IBOutlet weak var updateButton: DesignableButton!
    
    var editable : Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Edit Profile"
        
        if editable == false {
            ([nameField,emailField,addressField,cityField,heightField,countryField,weightField,occupationField,serviceField,specializationField,degreeField] as [UITextField]).forEach({ (field) in
                field.isUserInteractionEnabled = false
            })
            
            profileImageView.isUserInteractionEnabled = false
            maritalStatusControl.isUserInteractionEnabled = false
            
            let button = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.editButtonPressed))
            navigationItem.rightBarButtonItem = button
            
            let leftButton = UIBarButtonItem(image: UIImage(named: "menu-button-white"), style: .plain, target: self, action: #selector(self.menuButtonPressed))
            navigationItem.leftBarButtonItem = leftButton
            
            updateButton.isHidden = true
            title = "Profile"
        }
        
        [countryField,occupationField,serviceField,specializationField,cityField].forEach { (field) in
            let padding = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
            field?.leftViewMode = UITextFieldViewMode.always
            field?.leftView = padding
            
            field?.autoCompleteDelegate = self
            field?.autoCompleteDataSource = self
        }
        
        profileImageView.parentController = self
        
        let user = ApplicationManager.sharedInstance.user
        
        
        //Universal fields
        self.nameField.text = user.full_name
        self.emailField.text = user.email
        if let avatar = URL(string: user.avatar ?? "") {
            self.profileImageView.sd_setImage(with: avatar, placeholderImage: UIImage(named: "user-image2"), options: [SDWebImageOptions.refreshCached, SDWebImageOptions.retryFailed], completed: nil)
        }
        self.addressField.text = user.address
        self.cityField.text = user.cityName
        self.countryField.text = user.countryName
        
        if ApplicationManager.sharedInstance.userType == .Doctor {
            //Doctor Fields
            doctorView.isHidden = false
            doctorSubmitConstraint.constant = -30
            self.degreeField.text = user.degree
            self.specializationField.text = user.specializationName
            
        }
        else{
            doctorView.isHidden = true
        }
        
        self.heightField.text = user.height
        self.weightField.text = user.weight
        
        if let index = user.marital_status?.rawValue {
            maritalStatusControl.selectedSegmentIndex = index-1
        }
        
        occupationField.text = user.occupationName
        // Do any additional setup after loading the view.
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        var params = [String: AnyObject]()
        
        params["first_name"] = nameField.text as AnyObject
        params["address"] = addressField.text as AnyObject
        params["city"] = cityField.text as AnyObject
        params["country"] = countryField.text as AnyObject
        params["email"] = emailField.text as AnyObject
        if ApplicationManager.sharedInstance.userType == .Patient {
            params["height"] = heightField.text as AnyObject
            params["weight"] = weightField.text as AnyObject
            params["occupation"] = occupationField.text as AnyObject
            params["marital_status"] = "\(maritalStatusControl.selectedSegmentIndex+1)" as AnyObject
        }
        else{
            params["specialization"] = specializationField.text as AnyObject
            params["services"] = [serviceField.text] as AnyObject
            params["degree"] = degreeField.text as AnyObject
        }
        
        SVProgressHUD.show(withStatus: "Updating Profile")
        RequestManager.editUser(param: params, image: profileImageView.image, successBlock: { (response) in
            let user = User(dictionary: response)
            ApplicationManager.sharedInstance.user = user
            SVProgressHUD.showSuccess(withStatus: "Updated")
            self.navigationController?.popViewController(animated: true)
        }) { (error) in
            if let err = error as? String {
                SVProgressHUD.showError(withStatus: err)
            }
            else {
                SVProgressHUD.showError(withStatus: "Please verify the fields again")
            }
            
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
    
    func autoCompleteTextField(_ textField: MLPAutoCompleteTextField!, didSelectAutoComplete selectedString: String!, withAutoComplete selectedObject: MLPAutoCompletionObject!, forRowAt indexPath: IndexPath!) {
        
    }
    
    func editButtonPressed() {
        Router.sharedInstance.showEditProfile(fromController: self)
    }
    
    func menuButtonPressed() {
        
        self.presentLeftMenuViewController(nil)
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
