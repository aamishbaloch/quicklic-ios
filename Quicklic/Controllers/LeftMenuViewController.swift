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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LeftMenuTableViewCell.identifier) as! LeftMenuTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "Dashboard"
        case 1:
            cell.titleLabel.text = "New Appointment"
        case 2:
            cell.titleLabel.text = "Edit Profile"
        case 3:
            cell.titleLabel.text = "Appointment History"
        case 4:
            cell.titleLabel.text = "Logout"
        default:
            cell.titleLabel.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == selectedIndex {
            Router.sharedInstance.hideSideMenu()
            selectedIndex = indexPath.row
            return
        }
        
        switch indexPath.row {
        case 0:
            Router.sharedInstance.showPatientDashboard()
        case 1:
            Router.sharedInstance.showSearchDoctor()
        case 2:
            Router.sharedInstance.showPatientEditProfile()
        case 3:
            Router.sharedInstance.showAppointmentHistory()
        case 4:
            Router.sharedInstance.showLandingPage()
        default: break
            
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
