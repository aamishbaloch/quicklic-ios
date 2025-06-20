//
//  CreateAppointmentViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 01/11/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class CreateAppointmentViewController: UIViewController,ReasonSelectionDelegate,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    
    
    static let storyboardID = "createAppointmentViewController"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: DesignableImageView!
    @IBOutlet weak var specialityLabel: UILabel!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var reasonButton: UIButton!
    @IBOutlet weak var clinicButton: UIButton!
    @IBOutlet weak var textview: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dateField: DatePickerTextField!
    
    var doctor: User?
    var reasons = [GenericModel]()
    var selectedReason: GenericModel?
    var clinicArray = [Clinic]()
    var selectedClinic : Clinic?
    var startTime:NSDate?
    var selectedTimeIndex = -1
    var timeArray = [Time]()
    
    var appointment = Appointment()
    var isEditingMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        
        
        dateField.pickerView.minimumDate = NSDate() as Date
        dateField.pickerView.maximumDate = nil
        
        nameLabel.text = doctor?.full_name ?? "N/A"
        phoneLabel.text = doctor?.phone ?? "N/A"
        specialityLabel.text = doctor?.specializationName ?? "N/A"
        profileImageView.sd_setImage(with: URL(string: doctor?.thumb ?? ""), placeholderImage: UIImage(named: "user-image2"), options: [SDWebImageOptions.refreshCached, SDWebImageOptions.retryFailed], completed: nil)
        dateField.text = UtilityManager.stringFromNSDateWithFormat(date: NSDate(), format: Constant.appDateFormat)
        let floatValue : Float = NSString(string: doctor?.rating ?? "0").floatValue
        ratingView.value = CGFloat(floatValue)
        
     
        if let doctorID = doctor?.id {
            RequestManager.getDoctorClinicsList(doctorID: doctorID, successBlock: { (response) in
                self.clinicArray.removeAll()
                for object in response {
                    self.clinicArray.append(Clinic(dictionary: object))
                }
                self.selectedClinic = self.clinicArray.first
                self.didSelectClinic(clinic: self.selectedClinic!)
                self.fetchTime(dateString: self.dateField.text)
            }) { (error) in
                SVProgressHUD.showError(withStatus: error)
            }
        }
        
        if isEditingMode {
            selectedReason = appointment.reason
            reasonButton.setTitle(appointment.reason.name, for: .normal)
            dateField.text = UtilityManager.stringFromNSDateWithFormat(date: appointment.start_datetime! as NSDate, format: Constant.appDateFormat)
            
        }
        
        textview.layer.borderWidth = 1
        textview.layer.cornerRadius = 5
        textview.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didSelectReason(reason: GenericModel) {
        
        selectedReason = reason
        print("selected reason is:\(String(describing: selectedReason?.name))")
        
        if let isReason = selectedReason {
            reasonButton.setTitle("\(isReason.name ?? "")  ", for: .normal)
        }
        else{
            SVProgressHUD.showError(withStatus: "Please select reason")
            return
        }
    }
    
    func didSelectClinic(clinic: Clinic) {
        selectedClinic = clinic
        
        if let clinic = selectedClinic {
            clinicButton.setTitle("\(clinic.name ?? "")  ", for: .normal)
        }
        else{
            SVProgressHUD.showError(withStatus: "Please select clinic")
            return
        }
    }
    
    @IBAction func reasonButtonPressed(_ sender: Any) {
        Router.sharedInstance.reasonSelection(fromController: self)
    }
    
    @IBAction func clinicButtonPressed(_ sender: Any) {
        Router.sharedInstance.clinicSelection(fromController: self, clinics: self.clinicArray)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        creatAppointment()
        
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func didEndEditingDateField(_ sender: DatePickerTextField) {
        fetchTime(dateString: dateField.text)
    }
    
    func fetchTime(dateString: String? = nil){
        
        guard let date = dateString else { return }
        guard let clinicID = self.selectedClinic?.id else { return }
        let convertedDate = UtilityManager.serverDateStringFromAppDateString(date: date)
        let params = ["date": convertedDate]
        
        SVProgressHUD.show()
        RequestManager.getTimeList(doctorID: (doctor?.id)!, clinicID: clinicID, params: params, successBlock: { (response) in
            self.timeArray.removeAll()
            for object in response {
                self.timeArray.append(Time(dictionary: object))
            }
            
            self.timeArray = self.timeArray.filter { $0.available == true }
            
            self.collectionView.reloadData()
            SVProgressHUD.dismiss()
            
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.timeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreatAppointmentCollectionViewCell.identifier, for: indexPath) as! CreatAppointmentCollectionViewCell
        
        if let startTime = self.timeArray[indexPath.row].start {
            cell.timelbl.text = UtilityManager.stringFromNSDateWithFormat(date: startTime, format: "hh:mm a")
        }
        
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        
        if indexPath.item == selectedTimeIndex {
            cell.layer.borderWidth = 0.0
            cell.backgroundColor = Styles.sharedStyles.primaryColor
            cell.timelbl.textColor = .white
        }
        else{
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.backgroundColor = .white
            cell.timelbl.textColor = .black
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.allowsMultipleSelection = false
        selectedTimeIndex = indexPath.item
        collectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width/3) - 6
        
        return CGSize(width: width, height: 30)
    }
    
    func creatAppointment(){
        
        guard let appointmentDate = dateField.text else {
            SVProgressHUD.showError(withStatus: "Please select date")
            return
        }
        
        var start = ""
        var end = ""
        
        guard let reason = selectedReason else {
            SVProgressHUD.showError(withStatus: "Please select reason")
            return
        }
        if selectedTimeIndex >= 0 {
            if let startTime = self.timeArray[selectedTimeIndex].start {
                let startDateString = UtilityManager.serverDateStringFromAppDateString(date: appointmentDate)
                let startTimeString = UtilityManager.stringFromNSDateWithFormat(date: startTime, format: "HH:mm:ss")
                start = "\(startDateString)T\(startTimeString)"
                print("Start date is: \(start)")
            }
            else{
                SVProgressHUD.showError(withStatus: "Please select time")
                return
            }
        }
        else{
            SVProgressHUD.showError(withStatus: "Please select time")
            return
        }
        
        guard let clinicID = self.selectedClinic?.id as? String else {
            SVProgressHUD.showError(withStatus: "Clinic not selected")
            return
        }
        
        
        if let endTime = self.timeArray[selectedTimeIndex].end {
            let endDateString = UtilityManager.serverDateStringFromAppDateString(date: appointmentDate)
            let endTimeString = UtilityManager.stringFromNSDateWithFormat(date: endTime, format: "HH:mm:ss")
            end = "\(endDateString)T\(endTimeString)"
            print("End date is: \(end)")
        }
        else{
            
        }
     
        var params = [String: Any]()
        params["start_datetime"] = start
        params["end_datetime"] = end
        params["clinic"] = clinicID
        params["status"] = 2
        params["notes"] = textview.text
        if let doctorId = doctor?.id {
            params["doctor"] = doctorId
        }
        if let patient = ApplicationManager.sharedInstance.user.id {
            params["patient"] = patient
        }
        if let reason = reason.id {
            params["reason"] = reason
        }
        
        if !isEditingMode{
            SVProgressHUD.show()
            RequestManager.createAppointment(params:params, successBlock: { (response) in
                // SVProgressHUD.showSuccess(withStatus: "Appointment created successfully")
                self.dismiss(animated: false, completion: nil)
                SVProgressHUD.dismiss()
                let appointment = Appointment(dictionary: response)
                Router.sharedInstance.showConfirmation(appointment: appointment, fromController: self)
            }) { (error) in
                SVProgressHUD.showError(withStatus: error)
                print(error)
            }
        }else{
            SVProgressHUD.show()
            RequestManager.editAppointment(appointmentID: appointment.id!, params:params, successBlock: { (response) in
                // SVProgressHUD.showSuccess(withStatus: "Appointment created successfully")
                self.dismiss(animated: false, completion: nil)
                SVProgressHUD.dismiss()
                let appointment = Appointment(dictionary: response)
                Router.sharedInstance.showConfirmation(appointment: appointment, fromController: self)
            }) { (error) in
                SVProgressHUD.showError(withStatus: error)
                print(error)
            }
        }
    }
    
    
    
    //MARK : - EmptyDataSource Methods
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No Slots Found"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center
        
        let attributes : [String: Any] = [NSFontAttributeName: UIFont(font: .Medium, size: 14.0) as Any,
                                          NSForegroundColorAttributeName: UIColor(red: 170.0/255.0, green: 171.0/255.0, blue: 179.0/255.0, alpha: 1.0),
                                          NSParagraphStyleAttributeName: paragraphStyle]
        return NSMutableAttributedString(string: text, attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = ""
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center
        
        let attributes : [String: Any] = [NSFontAttributeName: UIFont(font: .Standard, size: 15.0) as Any,
                                          NSForegroundColorAttributeName: UIColor(red: 170.0/255.0, green: 171.0/255.0, blue: 179.0/255.0, alpha: 1.0),
                                          NSParagraphStyleAttributeName: paragraphStyle]
        return NSMutableAttributedString(string: text, attributes: attributes)
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let text = ""
        
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
        
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        
    }
}
