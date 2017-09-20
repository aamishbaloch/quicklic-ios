//
//  EditProfileViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 29/08/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    static let storyboardID = "editProfileViewController"
    
    @IBOutlet weak var nameField: DesignableTextField!
    @IBOutlet weak var phoneField: DesignableTextField!
    @IBOutlet weak var addressField: DesignableTextField!
    @IBOutlet weak var dobField: DesignableTextField!
    @IBOutlet weak var emailField: DesignableTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Edit Profile"
        
        if ApplicationManager.sharedInstance.userType == .Doctor {
            phoneField.placeholder = "Speciality"
            addressField.placeholder = "Phone Number"
            dobField.placeholder = "Degree"
            emailField.placeholder = "Experience"
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func menuButtonPressed(_ sender: Any) {
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
