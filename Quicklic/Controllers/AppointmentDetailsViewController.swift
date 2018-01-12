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

class AppointmentDetailsViewController: UIViewController,commentDelegate {
    
    static let storyboardID = "appointmentDetailsViewController"
    
    @IBOutlet weak var imageView: DesignableImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var reasonforvisitLabel: UILabel!
    @IBOutlet weak var selectedtimeLabel: UILabel!
    @IBOutlet weak var appointmentStatusView: UIView!
    @IBOutlet weak var pendingConfirmationLabel: UILabel!
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var patientView: UIView!
    @IBOutlet weak var appointmentStatusLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var notesLabelFromvisit: UILabel!
    @IBOutlet weak var statusfromVisitLabel: UILabel!
    @IBOutlet weak var viewFromVisit: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var doctorNotesLabel: UILabel!
    @IBOutlet weak var drNotes: UILabel!
    @IBOutlet weak var patientNotes: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var doctorsButtonView: UIView!
    @IBOutlet weak var patientsButtonView: UIView!
    @IBOutlet weak var appointmentStatusButtonView: UIView!
    
    @IBOutlet weak var viewPatientButton: UIButton!
    @IBOutlet weak var specialityLabel: UILabel!
    @IBOutlet weak var doctorRatingView: HCSStarRatingView!
    
    
    
    var appointment = Appointment()
    var doctor:User?
    var delegate:AppointmentStatusDelegate?
    var appointmentIndex: Int?
    var parentController: UIViewController?
    var isVisit : Bool = false
    var comments:String?
    var visitArray = [Visit]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        idLabel.text = appointment.qid
        
        if  ApplicationManager.sharedInstance.userType == .Doctor
        {
            appointmentStatusView.isHidden = false
            patientView.isHidden =  true
            viewPatientButton.isHidden = false
            specialityLabel.isHidden = true
            doctorRatingView.isHidden = true
            
        }else{
            appointmentStatusView.isHidden = true
            patientView.isHidden = false
            viewPatientButton.isHidden = true
            specialityLabel.isHidden = false
            doctorRatingView.isHidden = false
            
        }
        
        if !isVisit {
            viewFromVisit.isHidden = true
        }else{
            viewFromVisit.isHidden = false
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func comments(textdata: String) {
        comments = textdata
        addVisit()
    }
    
    func addVisit(){
        
        var params = [String: Any]()
        
        params["clinic"] = appointment.clinic.id
        params["doctor"] = appointment.doctor.id
        params["patient"] = appointment.patient.id
        params["appointment"] = appointment.id
        params["comments"] = comments
        
        SVProgressHUD.show()
        RequestManager.addVisit(appointmentID: appointment.id!, params:params, successBlock: { (response) in
            
            SVProgressHUD.dismiss()
            self.dismiss(animated: false, completion: nil)
            self.delegate?.appointmenConfirmation(status: AppointmentStatus.Confirm, index: 0)
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
            print(error)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if ApplicationManager.sharedInstance.userType == .Patient {
            specialityLabel.text = appointment.doctor.specializationName
            let floatValue : Float = NSString(string: appointment.doctor.rating ?? "0").floatValue
            doctorRatingView.value = CGFloat(floatValue)
            doctorData()
        }
        else{
            patientData()
        }
        
        if appointment.status == .Discard || appointment.status == .NoShow || appointment.status == .Cancel || appointment.status == .Done {
            doctorsButtonView.isHidden = true
            patientsButtonView.isHidden = true
            appointmentStatusButtonView.isHidden = true
        }
    }
    
    func doctorData(){
        nameLabel.text = appointment.doctor.full_name ?? "N/A"
        
        
        imageView.sd_setImage(with: URL(string: appointment.doctor.avatar ?? ""), placeholderImage: UIImage(named: "user-image2"), options: SDWebImageOptions.refreshCached, completed: nil)
        if let startTime = appointment.start_datetime {
            selectedtimeLabel.text = UtilityManager.stringFromNSDateWithFormat(date: startTime as NSDate, format: "hh:mm a")
        }
        reasonforvisitLabel.text = appointment.reason.name ?? "N/A"
        
        if let status = appointment.status?.value
        {
            appointmentStatusLabel.text = status
            print("Status is : \(String(describing: status))")
        }
        if appointment.status?.value == "Confirmed"
        {
            appointmentStatusLabel.textColor = UIColor.green
        }else if appointment.status?.value == "Pending" {
            appointmentStatusLabel.textColor = UIColor.orange
        }else if appointment.status?.value == "No Show" {
            appointmentStatusLabel.textColor = UIColor.red
            //pendingConfirmationLabel.textColor = UIColor.yellow
            //statusfromVisitLabel.textColor = UIColor.yellow
            
        }
        else if appointment.status?.value == "Done" {
            appointmentStatusLabel.textColor = .green
        }
        else{
            appointmentStatusLabel.textColor = UIColor.red
        }
        selectedDateLabel.text = UtilityManager.stringFromNSDateWithFormat(date:appointment.start_datetime! as NSDate , format: Constant.appDateFormat)
        
        notesLabel.text = appointment.notes ?? "No notes provided"
        drNotes.text =  appointment.visit.comments ?? "There are no doctor notes."
        
    }
    
    func patientData () {
        nameLabel.text = appointment.patient.full_name ?? "N/A"
        imageView.sd_setImage(with: URL(string: appointment.patient.avatar ?? ""), placeholderImage: UIImage(named: "user-image2"), options: SDWebImageOptions.refreshCached, completed: nil)
        if let startTime = appointment.start_datetime {
            selectedtimeLabel.text = UtilityManager.stringFromNSDateWithFormat(date: startTime as NSDate, format: "hh:mm a")
        }
        notesLabelFromvisit.text = appointment.notes ?? "No notes provided"
        reasonforvisitLabel.text = appointment.reason.name ?? "N/A"
        drNotes.text = appointment.visit.comments ?? "There are no doctor notes."
        notesLabel.text = appointment.notes ?? "There are no doctor notes."
        patientNotes.text = appointment.notes ?? ""
        pendingConfirmationLabel.text = appointment.status?.value ?? "N/A"
        selectedDateLabel.text = UtilityManager.stringFromNSDateWithFormat(date:appointment.start_datetime! as NSDate , format: Constant.appDateFormat)
        notesLabel.text = appointment.notes
        if let status = appointment.status?.value
        {
            statusfromVisitLabel.text = status
            
            print("Status is : \(String(describing: status))")
        }
        if appointment.status?.value == "Confirmed"
        {
            pendingConfirmationLabel.textColor = UIColor.green
            statusfromVisitLabel.textColor = UIColor.green
            
        }else if appointment.status?.value == "Pending" {
            
            pendingConfirmationLabel.textColor = UIColor.orange
            statusfromVisitLabel.textColor = UIColor.orange
            
        }else if appointment.status?.value == "No Show" {
            
            //            pendingConfirmationLabel.textColor = UIColor.yellow
            //            statusfromVisitLabel.textColor = UIColor.yellow
            
        }else{
            
            pendingConfirmationLabel.textColor = UIColor.red
            statusfromVisitLabel.textColor = UIColor.red
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
        
        let params = ["status":AppointmentStatus.Confirm.rawValue]
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
        
        let params = ["status": AppointmentStatus.Discard.rawValue]
        print("Appointment Id \(String(describing: appointment.id))")
        SVProgressHUD.show()
        RequestManager.appointmentStatus(doctorID:appointment.doctor.id!, appointmentID: appointment.id! , params: params, successBlock: { (response) in
            
            self.delegate?.appointmenConfirmation(status: AppointmentStatus(rawValue: AppointmentStatus.Discard.rawValue)!, index: self.appointmentIndex!)
            
            SVProgressHUD.dismiss()
            self.dismiss(animated: false, completion: nil)
        }, failureBlock: { (error) in
            SVProgressHUD.showError(withStatus: error)
        })
        
    }
    
    func noShow(){
        
        let params = ["status": AppointmentStatus.NoShow.rawValue]
        print("Appointment Id \(String(describing: appointment.id))")
        SVProgressHUD.show()
        RequestManager.appointmentStatus(doctorID:appointment.doctor.id!, appointmentID: appointment.id! , params: params, successBlock: { (response) in
            
            self.delegate?.appointmenConfirmation(status: AppointmentStatus.NoShow, index: self.appointmentIndex!)
            
            SVProgressHUD.dismiss()
            self.dismiss(animated: false, completion: nil)
        }, failureBlock: { (error) in
            SVProgressHUD.showError(withStatus: error)
        })
        
    }
    
    
    @IBAction func editButtonPressed(_ sender: DesignableButton) {
        
        // Router.sharedInstance.createAppointment(doctor: doctor?.id, fromController: self)
        self.dismiss(animated: false) {
            Router.sharedInstance.editAppointment(appointment: self.appointment, fromController: self.parentController!)
        }
        
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
            //current cancel
            SVProgressHUD.showSuccess(withStatus: "Appointment cancelled successfully")
            // SVProgressHUD.dismiss()
            self.delegate?.appointmenConfirmation(status: .Cancel, index: self.appointmentIndex!)
            self.dismiss(animated: false, completion: nil)
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
        }
        
    }
    
    @IBAction func viewPatientButtonPressed(_ sender: Any) {
        Router.sharedInstance.showOtherProfile(user: appointment.patient, fromController: self)
    }
    
    
    @IBAction func noShowButtonPressed(_ sender: Any) {
        noShow()
    }
    
    @IBAction func completeButtonPressed(_ sender: Any) {
        
        Router.sharedInstance.showCommentView(fromController: self)
        
    }
    /*
     @IBAction func completeButtonPressed(_ sender: DesignableButton) {
     }
     
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
