//
//  ProfileViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 18/10/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    static let storyboardID = "profileViewController"

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImageView: DesignableImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "Profile"
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        user = ApplicationManager.sharedInstance.user
//        nameLabel.text = user.full_name
//        profileImageView.sd_setImage(with: URL(string: user.avatar ?? ""), placeholderImage: UIImage(named: "placeholder-image"), options: SDWebImageOptions.refreshCached, completed: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        user = ApplicationManager.sharedInstance.user
        nameLabel.text = user.full_name
        profileImageView.sd_setImage(with: URL(string: user.avatar ?? ""), placeholderImage: UIImage(named: "placeholder-image"), options: SDWebImageOptions.refreshCached, completed: nil)
        tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if user.userType == .Patient {
            return 11
        }
        else{
            return 10
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier) as! ProfileTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.headingLabel.text = "Phone Number"
            cell.bodyLabel.text = user.phone ?? "N/A"
        case 1:
            cell.headingLabel.text = "Email"
            cell.bodyLabel.text = user.email ?? "N/A"
        case 2:
            cell.headingLabel.text = "Gender"
            cell.bodyLabel.text = user.gender?.value ?? "N/A"
        case 3:
            cell.headingLabel.text = "Date of Birth"
            if let dob = user.dob {
                cell.bodyLabel.text = UtilityManager.stringFromNSDateWithFormat(date: dob, format: Constant.appDateFormat)
            }
            else{
                cell.bodyLabel.text = "N/A"
            }
        case 4:
            cell.headingLabel.text = "Address"
            cell.bodyLabel.text = user.address ?? "N/A"
        case 5:
            cell.headingLabel.text = "City"
            cell.bodyLabel.text = user.cityName ?? "N/A"
        case 6:
            cell.headingLabel.text = "Country"
            cell.bodyLabel.text = user.countryName ?? "N/A"
        case 7:
            if user.userType == .Patient {
                cell.headingLabel.text = "Height"
                cell.bodyLabel.text = user.height ?? "N/A"
            }
            else{
                cell.headingLabel.text = "Services"
                cell.bodyLabel.text = user.servicesArray.joined(separator: ", ")
            }
        case 8:
            if user.userType == .Patient {
                cell.headingLabel.text = "Weight"
                cell.bodyLabel.text = user.weight ?? "N/A"
            }
            else{
                cell.headingLabel.text = "Specialization"
                cell.bodyLabel.text = user.specializationName ?? "N/A"
            }
        case 9:
            if user.userType == .Patient {
                cell.headingLabel.text = "Marital Status"
                cell.bodyLabel.text = user.marital_status?.value ?? "N/A"
            }
            else{
                cell.headingLabel.text = "Degree"
                cell.bodyLabel.text = user.degree
            }
            
        case 10:
            cell.headingLabel.text = "Occupation"
            cell.bodyLabel.text = user.occupationName ?? "N/A"
        default: break
        }
        
        return cell
        
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
