//
//  PatientDashboardViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 27/08/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class PatientDashboardViewController: UIViewController, ScrollableDatepickerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    static let storyboardID = "patientContentController"
    
    @IBOutlet weak var datePicker: ScrollableDatepicker!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newAppointmentButton: DesignableButton!
    @IBOutlet weak var profileImageView: DesignableImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var appointmentsArray = [Appointment]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Dashboard"
        
        setupDatePicker()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let user = ApplicationManager.sharedInstance.user
        if user.userType == nil {
            
            var params = [String: String]()
            params["phone"] = UserDefaults.standard.value(forKey: "userPhone") as? String
            params["password"] = UserDefaults.standard.value(forKey: "userPassword") as? String

            SVProgressHUD.show()
            RequestManager.loginUser(param: params, successBlock: { (response: [String : AnyObject]) in
//                SVProgressHUD.dismiss()
                
                let user = User(dictionary: response)
                ApplicationManager.sharedInstance.user = user
                
                UserDefaults.standard.set(response["token"] as! String, forKey: "token")
    
                if response["role"] as! Int == Role.Patient.rawValue {
                    ApplicationManager.sharedInstance.userType = .Patient
                }
                else{
                    ApplicationManager.sharedInstance.userType = .Doctor
                }
                self.updateUI(user: user)
                self.fetchData()
            }) { (error) in
                SVProgressHUD.showError(withStatus: error)
                UserDefaults.standard.set("", forKey: "token")
                Router.sharedInstance.showLandingPage()
                print(error)
            }
        }
        else{
            updateUI(user: user)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    func updateUI(user: User) {
        nameLabel.text = user.full_name
        profileImageView.sd_setImage(with: URL(string: user.avatar ?? ""), placeholderImage: UIImage(named: "placeholder-image"), options: SDWebImageOptions.refreshCached, completed: nil)
        
        if ApplicationManager.sharedInstance.userType == .Doctor {
            newAppointmentButton.setTitle("Patients", for: UIControlState.normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupDatePicker() {
        var dates = [Date]()
        for day in -15...15 {
            dates.append(Date(timeIntervalSinceNow: Double(day * 86400)))
        }
        
        datePicker.dates = dates
        datePicker.selectedDate = Date()
        datePicker.delegate = self
        
        var configuration = Configuration()
        
        configuration.weekendDayStyle.weekDayTextColor = UIColor(red: 242.0/255.0, green: 93.0/255.0, blue: 28.0/255.0, alpha: 1.0)
        
        // selected date customization
        configuration.selectedDayStyle.selectorColor = UIColor(hex: "#007AFF")
        configuration.daySizeCalculation = .numberOfVisibleItems(5)
        
        datePicker.configuration = configuration
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        self.presentLeftMenuViewController(nil)
    }
    
    func fetchData() {
        
        var params = [String: Any]()
        params["start_date"] = "2017-11-17"
        
        RequestManager.getAppointments(params:params, successBlock: { (response) in
            self.appointmentsArray.removeAll()
            for object in response {
                self.appointmentsArray.append(Appointment(dictionary: object))
                print("Array is : \(object)")
            }
            self.collectionView.reloadData()
            SVProgressHUD.dismiss()
            
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
        }
        
    }
    
    
    func datepicker(_ datepicker: ScrollableDatepicker, didSelectDate date: Date) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appointmentsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DoctorAppointmentCollectionViewCell.identifier, for: indexPath) as! DoctorAppointmentCollectionViewCell
        let appointment = appointmentsArray[indexPath.item]
        
        
        if ApplicationManager.sharedInstance.userType == .Patient {
            cell.nameLabel.text = appointment.doctor.full_name
            cell.specializationLabel.text = appointment.doctor.specializationName
            cell.drImage.sd_setImage(with: URL(string: appointment.doctor.avatar ?? ""), placeholderImage: UIImage(named: "placeholder-image"), options: SDWebImageOptions.refreshCached, completed: nil)
        }
        else{
            cell.nameLabel.text = appointment.patient.full_name
            cell.specializationLabel.text = nil
            cell.drImage.sd_setImage(with: URL(string: appointment.patient.avatar ?? ""), placeholderImage: UIImage(named: "placeholder-image"), options: SDWebImageOptions.refreshCached, completed: nil)
        }
        
        if let startTime = self.appointmentsArray[indexPath.row].start_datetime {
            cell.timeLabel.text = UtilityManager.stringFromNSDateWithFormat(date: startTime as NSDate, format: "HH:mm a")
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Router.sharedInstance.showAppointmentDetails(appointment: self.appointmentsArray[indexPath.item], fromController: self)
    }
    
    
    @IBAction func newAppointmentButtonPressed(_ sender: Any) {
        Router.sharedInstance.showSearchDoctor()
    }
    
    @IBAction func appointmentHistoryButtonPressed(_ sender: Any) {
        Router.sharedInstance.showAppointmentHistory()
        
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
