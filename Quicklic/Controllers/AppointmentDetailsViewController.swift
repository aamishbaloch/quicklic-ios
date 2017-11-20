//
//  AppointmentDetailsViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 18/09/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class AppointmentDetailsViewController: UIViewController {
    
    static let storyboardID = "appointmentDetailsViewController"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var reasonforvisitLabel: UILabel!
    @IBOutlet weak var selectedLabel: UILabel!
    @IBOutlet weak var selectedtimeLabel: UILabel!
    @IBOutlet weak var appointmentStatusView: UIView!
    @IBOutlet weak var pendingConfirmationLabel: UILabel!
    
    var appointment: Appointment!
    var doctor:User?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
      if  ApplicationManager.sharedInstance.userType == .Doctor
      {
        appointmentStatusView.isHidden = false
      }else{
        appointmentStatusView.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        nameLabel.text = appointment.doctor.full_name ?? "N/A"
        phoneLabel.text = appointment.doctor.phone ?? "N/A"
        addressLabel.text = appointment.doctor.address ?? "N/A"
        emailLabel.text = appointment.doctor.email ?? "N/A"
        imageView.sd_setImage(with: URL(string: appointment.doctor.avatar ?? ""), placeholderImage: UIImage(named: "placeholder-image"), options: SDWebImageOptions.refreshCached, completed: nil)
        if let startTime = appointment.start_datetime {
            selectedtimeLabel.text = UtilityManager.stringFromNSDateWithFormat(date: startTime as NSDate, format: "HH:mm a")
        }
        reasonforvisitLabel.text = appointment.reason.name ?? "N/A"
    
    }
    
    
    @IBAction func okButtonPressed(_ sender: UIButton) {
     print("ok button pressed")
     let params = ["status": 1]
        print("Appointment Id \(String(describing: appointment.id))")
        SVProgressHUD.show()
        RequestManager.appointmentStatus(doctorID:appointment.doctor.id!, appointmentID: appointment.id! , params: params, successBlock: { (response) in
        
        self.pendingConfirmationLabel.text = "Confirmed"
        self.pendingConfirmationLabel.textColor = UIColor.green
        SVProgressHUD.dismiss()
        }, failureBlock: { (error) in
            SVProgressHUD.showError(withStatus: error)
        })
        
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        
        let params = ["status": 2]
        print("Appointment Id \(String(describing: appointment.id))")
        SVProgressHUD.show()
        RequestManager.appointmentStatus(doctorID:appointment.doctor.id!, appointmentID: appointment.id! , params: params, successBlock: { (response) in
            self.pendingConfirmationLabel.text = "Discard"
            self.pendingConfirmationLabel.textColor = UIColor.orange
            SVProgressHUD.dismiss()
        }, failureBlock: { (error) in
            SVProgressHUD.showError(withStatus: error)
        })
        
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
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
