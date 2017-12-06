//
//  PatientDashboardViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 27/08/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class PatientDashboardViewController: UIViewController, ScrollableDatepickerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,AppointmentStatusDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
  
    static let storyboardID = "patientContentController"
    
    @IBOutlet weak var datePicker: ScrollableDatepicker!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newAppointmentButton: DesignableButton!
    @IBOutlet weak var profileImageView: DesignableImageView!
    @IBOutlet weak var nameLabel: UILabel!
   
   
    var appointmentsArray = [Appointment]()
    var appointment = Appointment()
    var selectedDate:String?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Dashboard"
        
        setupDatePicker()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
   
        let user = ApplicationManager.sharedInstance.user
        if user.userType == nil {
            
            var params = [String: String]()
            params["phone"] = UserDefaults.standard.value(forKey: "userPhone") as? String
            params["password"] = UserDefaults.standard.value(forKey: "userPassword") as? String

            SVProgressHUD.show()
            RequestManager.loginUser(param: params, successBlock: { (response: [String : AnyObject]) in
            //SVProgressHUD.dismiss()
                
                let user = User(dictionary: response)
                ApplicationManager.sharedInstance.user = user
                
                UserDefaults.standard.set(response["token"] as! String, forKey: "token")
    
                if response["role"] as! Int == Role.Patient.rawValue {
                    ApplicationManager.sharedInstance.userType = .Patient
                }
                else{
                    ApplicationManager.sharedInstance.userType = .Doctor
                }
                if let leftController = self.sideMenuViewController.leftMenuViewController as? LeftMenuViewController{
                    leftController.tableView.reloadData()
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
    
    func appointmenConfirmation(status: AppointmentStatus, index: Int) {
        appointmentsArray[index].status = status
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
        if ApplicationManager.sharedInstance.user.id != nil {
            let date = Date()
            selectedDate = UtilityManager.stringFromNSDateWithFormat(date: date as NSDate, format: "yyyy-MM-dd")
            self.fetchData()
            collectionView.reloadData()
        }
        
        
    }
    
    func updateUI(user: User) {
        nameLabel.text = user.full_name
        profileImageView.sd_setImage(with: URL(string: user.avatar ?? ""), placeholderImage: UIImage(named: "user-image2"), options: [SDWebImageOptions.refreshCached, SDWebImageOptions.retryFailed], completed: nil)
        
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
        for day in -15...150 {
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

    func datepicker(_ datepicker: ScrollableDatepicker, didSelectDate date: Date) {
        
        selectedDate = UtilityManager.stringFromNSDateWithFormat(date: date as NSDate, format: "yyyy-MM-dd")
        //print("Did select date ! \(String(describing: selectedDate))")
        fetchData()
        
    }
    
    func fetchData() {
        
        var params = [String: Any]()
        if let date = selectedDate {
            params["start_date"] = date
            params["end_date"] = date
        }
        
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

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appointmentsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DoctorAppointmentCollectionViewCell.identifier, for: indexPath) as! DoctorAppointmentCollectionViewCell
        
        let appointment = appointmentsArray[indexPath.item]
        if ApplicationManager.sharedInstance.userType == .Patient {
            cell.nameLabel.text = appointment.doctor.full_name ?? "N/A"
            cell.specializationLabel.text = appointment.doctor.specializationName ?? "N/A"
            cell.drImage.sd_setImage(with: URL(string: appointment.doctor.avatar ?? ""), placeholderImage: UIImage(named: "user-image2"), options: [SDWebImageOptions.refreshCached, SDWebImageOptions.retryFailed], completed: nil)
        }
        else{
            cell.nameLabel.text = appointment.patient.full_name ?? "N/A"
            cell.specializationLabel.text = nil
            cell.drImage.sd_setImage(with: URL(string: appointment.patient.avatar ?? ""), placeholderImage: UIImage(named: "user-image2"), options: [SDWebImageOptions.refreshCached, SDWebImageOptions.retryFailed], completed: nil)
        }
        
        if let startTime = self.appointmentsArray[indexPath.row].start_datetime {
            cell.timeLabel.text = UtilityManager.stringFromNSDateWithFormat(date: startTime as NSDate, format: "hh:mm a")
        }
        let status = appointment.status?.value
        cell.statusLabel.text = status
        if status == "Confirmed"
        {
           cell.statusLabel.textColor = UIColor.green
        }else if status == "Pending" {
            cell.statusLabel.textColor = UIColor.orange
        }
        else if status == "Discard" {
            cell.statusLabel.textColor = UIColor.red
        }
        else if status == "Cancel" {
            cell.statusLabel.textColor = UIColor.red
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Router.sharedInstance.showAppointmentDetails(appointment: self.appointmentsArray[indexPath.item],appointmentIndex: indexPath.item, fromController: self)
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = self.collectionView.bounds.width
        
        return CGSize(width: cellWidth, height: 90)
    }
    
    @IBAction func newAppointmentButtonPressed(_ sender: Any) {
      
        if ApplicationManager.sharedInstance.userType == .Doctor {
         Router.sharedInstance.showPatientsList()
        }else{
         Router.sharedInstance.showSearchDoctor()
        }
    }
    
    @IBAction func appointmentHistoryButtonPressed(_ sender: Any) {
        Router.sharedInstance.showAppointmentHistory()
        
    }
    
    //MARK : - EmptyDataSource Methods
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No Appointments Found"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center
        
        let attributes : [String: Any] = [NSFontAttributeName: UIFont(font: .Medium, size: 17.0) as Any,
                                          NSForegroundColorAttributeName: UIColor(red: 170.0/255.0, green: 171.0/255.0, blue: 179.0/255.0, alpha: 1.0),
                                          NSParagraphStyleAttributeName: paragraphStyle]
        return NSMutableAttributedString(string: text, attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Create an appointment by clicking on the button above"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center
        
        let attributes : [String: Any] = [NSFontAttributeName: UIFont(font: .Standard, size: 15.0) as Any,
                                          NSForegroundColorAttributeName: UIColor(red: 170.0/255.0, green: 171.0/255.0, blue: 179.0/255.0, alpha: 1.0),
                                          NSParagraphStyleAttributeName: paragraphStyle]
        return NSMutableAttributedString(string: text, attributes: attributes)
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let text = "Reload"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center
        
        var color: UIColor!
        
        if state == .normal {
            color = UIColor(red: 44.0/255.0, green: 137.0/255.0, blue: 202.0/255.0, alpha: 1.0)
        }
        if state == .highlighted {
            color = UIColor(red: 106.0/255.0, green: 187.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        }
        
        let attributes : [String: Any] = [NSFontAttributeName: UIFont(font: .SemiBold, size: 14.0) as Any,
                                          NSForegroundColorAttributeName: color,
                                          NSParagraphStyleAttributeName: paragraphStyle]
        return NSMutableAttributedString(string: text, attributes: attributes)
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor(white: 1.0, alpha: 1.0)
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return false
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        SVProgressHUD.show()
        fetchData()
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        SVProgressHUD.show()
        fetchData()
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
