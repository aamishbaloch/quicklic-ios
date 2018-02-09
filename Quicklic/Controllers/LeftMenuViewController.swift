//
//  LeftMenuViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 25/08/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class LeftMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    static let storyboardID = "leftMenuViewController"
    
    var selectedIndex = 0
    let patientmenuItems = ["Dashboard", "Profile", "Clinics","Reviews","Notifications", "Test Labs", "Logout"]
    let doctorMenuItems = ["Dashboard","Profile","Reviews","Patients" ,"Notifications","Test Labs","Logout"]
    
    var doctorArray = [User]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clear
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch ApplicationManager.sharedInstance.userType {
        case .Doctor:
            return doctorMenuItems.count
        case .Patient:
            return patientmenuItems.count
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LeftMenuTableViewCell.identifier) as! LeftMenuTableViewCell
        
        switch ApplicationManager.sharedInstance.userType {
        case .Doctor:
            cell.titleLabel.text = doctorMenuItems[indexPath.row]
        case .Patient:
            cell.titleLabel.text = patientmenuItems[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if indexPath.row == selectedIndex {
//            Router.sharedInstance.hideSideMenu()
//            return
//        }
//        selectedIndex = indexPath.row
        
        switch ApplicationManager.sharedInstance.userType {
        case .Doctor:
            switch indexPath.row {
            case 0:
               Router.sharedInstance.showPatientDashboard()
//            case 1:
//                Router.sharedInstance.showAppointmentHistory()
//            case 2:
//                Router.sharedInstance.showPatientsList()
            case 1:
                Router.sharedInstance.showProfile()
            
            case 2:
                Router.sharedInstance.showReviews()
            case 3:
                Router.sharedInstance.showPatientsList()
            case 4:
                Router.sharedInstance.showNotificationList()
            case 5:
                Router.sharedInstance.showLabsList()
            case 6:
                RequestManager.logoutUser(successBlock: { (response) in
                    
                }, failureBlock: { (error) in
                    
                })
                Router.sharedInstance.showLandingPage()
            default: break
                
            }
        case .Patient:
            switch indexPath.row {
            case 0:
                Router.sharedInstance.showPatientDashboard()
//            case 1:
//                Router.sharedInstance.showSearchDoctor()
//            case 2:
//                Router.sharedInstance.showAppointmentHistory()
            case 1:
                 Router.sharedInstance.showProfile()
            case 2:
                Router.sharedInstance.showClinicsList()
            case 3:
                Router.sharedInstance.showReviews()

            case 4:
                // UserDefaults.standard.set("", forKey: "token")
               Router.sharedInstance.showNotificationList()
            case 5:
                Router.sharedInstance.showLabsList()
                
            case 6:
                RequestManager.logoutUser(successBlock: { (response) in
                    
                }, failureBlock: { (error) in
                    
                })
                Router.sharedInstance.showLandingPage()
            default: break
                
            }
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
