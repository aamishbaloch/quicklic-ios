//
//  ProfileViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 18/10/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    static let storyboardID = "profileViewNavController"
    static let storyboardIDForProfile = "profileViewController"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImageView: DesignableImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    var mainUser: User?
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        title = "Profile"
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 20
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorColor = UIColor.clear
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        tableView.tableFooterView = UIView()
        
        user = mainUser != nil ? mainUser! : ApplicationManager.sharedInstance.user
        
        if mainUser != nil {
            let doneButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.closeButtonPressed))
            
            self.navigationItem.rightBarButtonItem = doneButton
            self.navigationItem.leftBarButtonItem = nil
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameLabel.text = user.full_name
        phoneLabel.text = user.phone
        let url = URL(string: user.thumb ?? "")
        profileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "user-image2"), options: [SDWebImageOptions.refreshCached, SDWebImageOptions.retryFailed]) { (image, error, cacheType, url) in
            if error == nil {
                self.profileImageView.image = image
            }
            else{
                print(error ?? "")
            }
        }
        tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if user.userType == .Patient {
            return 10
        }
        else{
            return 9
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier) as! ProfileTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.headingLabel.text = "Email"
            cell.bodyField.text = user.email ?? "N/A"
        case 1:
            cell.headingLabel.text = "Gender"
            cell.bodyField.text = user.gender?.value ?? "N/A"
        case 2:
            cell.headingLabel.text = "Date of Birth"
            if let dob = user.dob {
                cell.bodyField.text = UtilityManager.stringFromNSDateWithFormat(date: dob, format: Constant.appDateFormat)
            }
            else{
                cell.bodyField.text = "N/A"
            }
        case 3:
            cell.headingLabel.text = "Address"
            cell.bodyField.text = user.address ?? "N/A"
        case 4:
            cell.headingLabel.text = "City"
            cell.bodyField.text = user.cityName ?? "N/A"
        case 5:
            cell.headingLabel.text = "Country"
            cell.bodyField.text = user.countryName ?? "N/A"
        case 6:
            if user.userType == .Patient || mainUser != nil {
                cell.headingLabel.text = "Height"
                cell.bodyField.text = user.height ?? "N/A"
            }
            else{
                cell.headingLabel.text = "Services"
                cell.bodyField.text = user.servicesArray.joined(separator: ", ")
            }
        case 7:
            if user.userType == .Patient || mainUser != nil {
                cell.headingLabel.text = "Weight"
                cell.bodyField.text = user.weight ?? "N/A"
            }
            else{
                cell.headingLabel.text = "Specialization"
                cell.bodyField.text = user.specializationName ?? "N/A"
            }
        case 8:
            if user.userType == .Patient || mainUser != nil {
                cell.headingLabel.text = "Marital Status"
                cell.bodyField.text = user.marital_status?.value ?? "N/A"
            }
            else{
                cell.headingLabel.text = "Degree"
                cell.bodyField.text = user.degree
            }
            
        case 9:
            cell.headingLabel.text = "Occupation"
            cell.bodyField.text = user.occupationName ?? "N/A"
        default: break
        }
        
        return cell
        
    }
    
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        
        self.presentLeftMenuViewController(nil)
    }
    
    func closeButtonPressed() {
        self.navigationController?.dismiss(animated: true, completion: nil)
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
