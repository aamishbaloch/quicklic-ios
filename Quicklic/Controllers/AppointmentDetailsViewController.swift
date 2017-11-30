//
//  AppointmentDetailsViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 18/09/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

protocol AppointmentStatusDelegate {

    func appointmenConfirmation(status:AppointmentStatus, index: Int)
    
}

class AppointmentDetailsViewController: UIViewController {
    
    static let storyboardID = "appointmentDetailsViewController"
    
    @IBOutlet weak var imageView: DesignableImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var reasonforvisitLabel: UILabel!
    @IBOutlet weak var selectedtimeLabel: UILabel!
    @IBOutlet weak var appointmentStatusView: UIView!
    @IBOutlet weak var pendingConfirmationLabel: UILabel!
    @IBOutlet weak var selectedDateLabel: UILabel!
      @IBOutlet weak var patientView: UIView!
    
    @IBOutlet weak var appointmentStatusLabel: UILabel!
    
    @IBOutlet weak var notesLabel: UILabel!
    
    
    var appointment: Appointment!
    var doctor:User?
    var delegate:AppointmentStatusDelegate?
    var appointmentIndex: Int?
    
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
      if  ApplicationManager.sharedInstance.userType == .Doctor
      {
        appointmentStatusView.isHidden = false
        patientView.isHidden =  true
      }else{
        appointmentStatusView.isHidden = true
        patientView.isHidden = false
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if ApplicationManager.sharedInstance.userType == .Patient {
            nameLabel.text = appointment.doctor.full_name ?? "N/A"
            phoneLabel.text = appointment.doctor.phone ?? "N/A"
            addressLabel.text = appointment.doctor.address ?? "N/A"
            emailLabel.text = appointment.doctor.email ?? "N/A"
            imageView.sd_setImage(with: URL(string: appointment.doctor.avatar ?? ""), placeholderImage: UIImage(named: "user-image-done"), options: SDWebImageOptions.refreshCached, completed: nil)
            if let startTime = appointment.start_datetime {
                selectedtimeLabel.text = UtilityManager.stringFromNSDateWithFormat(date: startTime as NSDate, format: "HH:mm a")
            }
            reasonforvisitLabel.text = appointment.reason.name ?? "N/A"
            pendingConfirmationLabel.text = appointment.status?.value ?? "N/A"
            selectedDateLabel.text = UtilityManager.stringFromNSDateWithFormat(date:appointment.start_datetime! as NSDate , format: Constant.appDateFormat)
            
        }
        else{
        nameLabel.text = appointment.patient.full_name ?? "N/A"
        phoneLabel.text = appointment.patient.phone ?? "N/A"
        addressLabel.text = appointment.patient.address ?? "N/A"
        emailLabel.text = appointment.patient.email ?? "N/A"
        imageView.sd_setImage(with: URL(string: appointment.patient.avatar ?? ""), placeholderImage: UIImage(named: "user-image-done"), options: SDWebImageOptions.refreshCached, completed: nil)
        if let startTime = appointment.start_datetime {
            selectedtimeLabel.text = UtilityManager.stringFromNSDateWithFormat(date: startTime as NSDate, format: "HH:mm a")
        }
        reasonforvisitLabel.text = appointment.reason.name ?? "N/A"
        pendingConfirmationLabel.text = appointment.status?.value ?? "N/A"
        selectedDateLabel.text = UtilityManager.stringFromNSDateWithFormat(date:appointment.start_datetime! as NSDate , format: Constant.appDateFormat)
        
        if appointment.status?.value == "Confirmed"
        {
            pendingConfirmationLabel.textColor = UIColor.green
        }else{
            pendingConfirmationLabel.textColor = UIColor.red
        }
    
      }
    }
    
    @IBAction func okButtonPressed(_ sender: UIButton) {

        UIAlertController.showAlert(in: self, withTitle: "Confirmation", message: "Are you sure you want to confirm?", cancelButtonTitle: "No", destructiveButtonTitle: nil, otherButtonTitles: ["Yes"]) { (alertController, alertAction, buttonIndex) in
            if buttonIndex == alertController.firstOtherButtonIndex {
                 self.confirmed()
            }
        }
    }
  
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
      
        UIAlertController.showAlert(in: self, withTitle: "Confirmation", message: "Are you sure you want to cancel?", cancelButtonTitle: "Yes", destructiveButtonTitle: nil, otherButtonTitles: ["No"]) { (alertController, alertAction, buttonIndex) in
            if buttonIndex == alertController.firstOtherButtonIndex {
                self.dismiss(animated: true, completion: nil)
            }
            else if buttonIndex == alertController.cancelButtonIndex {
                self.cancelled()
            }
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }

    func confirmed(){
        
        let params = ["status": 1]
        print("Appointment Id \(String(describing: appointment.id))")
        SVProgressHUD.show()
        RequestManager.appointmentStatus(doctorID:appointment.doctor.id!, appointmentID: appointment.id! , params: params, successBlock: { (response) in
            self.pendingConfirmationLabel.text = "Confirmed"
            self.pendingConfirmationLabel.textColor = UIColor.green
            
            self.delegate?.appointmenConfirmation(status: AppointmentStatus.Confirm, index: self.appointmentIndex!)

            SVProgressHUD.dismiss()
            self.dismiss(animated: false, completion: nil)
        }, failureBlock: { (error) in
            SVProgressHUD.showError(withStatus: error)
        })
    }
    
    func cancelled(){
        
        let params = ["status": 5]
        print("Appointment Id \(String(describing: appointment.id))")
        SVProgressHUD.show()
        RequestManager.appointmentStatus(doctorID:appointment.doctor.id!, appointmentID: appointment.id! , params: params, successBlock: { (response) in
            
            self.delegate?.appointmenConfirmation(status: AppointmentStatus.Discard, index: self.appointmentIndex!)

            SVProgressHUD.dismiss()
            self.dismiss(animated: false, completion: nil)
        }, failureBlock: { (error) in
            SVProgressHUD.showError(withStatus: error)
        })
  
    }
    
    
   
    @IBAction func editButtonPressed(_ sender: DesignableButton) {
        
        Router.sharedInstance.createAppointment(doctor: doctor!, fromController: self)
        
    }
    
    
    @IBAction func cancelButtonPressedPatient(_ sender: Any) {
        self.cancelAppointment()
    }
   
    func cancelAppointment() {
        SVProgressHUD.show()
        guard let patientId = appointment.patient.id else { return }
        guard let appointmentId = appointment.id else { return }
        
        print("Patient is: \(String(describing: patientId))")
        print("Appointment id is: \(String(describing: appointmentId))")
        
        RequestManager.cancelAppointment(patientID: patientId, appointmentID:appointmentId, successBlock: { (response) in
          
              SVProgressHUD.showSuccess(withStatus: "Appointment cancelled successfully")
           // SVProgressHUD.dismiss()
            //self.dismiss(animated: false, completion: nil)
            }) { (error) in
            SVProgressHUD.showError(withStatus: error)
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
