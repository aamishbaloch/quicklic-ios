//
//  CreateAppointmentViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 01/11/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class CreateAppointmentViewController: UIViewController,ReasonSelectionDelegate,UICollectionViewDelegate,UICollectionViewDataSource{
    

    static let storyboardID = "createAppointmentViewController"

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: DesignableImageView!
    @IBOutlet weak var specialityLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var reasonButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dateField: DatePickerTextField!
    
    var doctor: User?
    var reasons = [GenericModel]()
    var selectedReason: GenericModel?
    var clinicID = ""
    
    var timeArray = [Time]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        dateField.pickerView.minimumDate = NSDate() as Date
        dateField.pickerView.maximumDate = nil
        
        dateField.text = UtilityManager.stringFromNSDateWithFormat(date: NSDate(), format: Constant.appDateFormat)
        
        if let doctorID = doctor?.id {
            RequestManager.getDoctorClinicsList(doctorID: doctorID, successBlock: { (response) in
                let clinic = Clinic(dictionary: response.first)
                self.clinicID = clinic.id!
            }) { (error) in
                SVProgressHUD.showError(withStatus: error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didSelectReason(reason: GenericModel) {
        selectedReason = reason
        print("selected reason is:\(String(describing: selectedReason?.name))")
        reasonButton.setTitle("\(selectedReason?.name ?? "")   ", for: .normal)
    }
  
    @IBAction func reasonButtonPressed(_ sender: Any) {
        Router.sharedInstance.reasonSelection(fromController: self)
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
        
        let convertedDate = UtilityManager.serverDateStringFromAppDateString(date: date)
        let params = ["date": convertedDate]
        
        SVProgressHUD.show()
        RequestManager.getTimeList(doctorID: (doctor?.id)!,params: params, successBlock: { (response) in
 
            for object in response {
            self.timeArray.append(Time(dictionary: object))
            }
            self.collectionView.reloadData()
            SVProgressHUD.dismiss()
            
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
        }
    }
   
    func creatAppointment(){
        
        var params = [String: Any]()
        params["start_datetime"] = "2017-11-15T12:00:00"
        params["end_datetime"] = "2017-11-15T12:50:00"
        params["clinic"] = clinicID
        params["doctor"] = doctor?.id
        params["patient"] = ApplicationManager.sharedInstance.user.id
        params["reason"] = selectedReason?.id
        params["status"] = 2
        
        
        SVProgressHUD.show()
        RequestManager.createAppointment(params:params, successBlock: { (response) in
            SVProgressHUD.dismiss()
            
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
            print(error)
        }
        
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.timeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreatAppointmentCollectionViewCell.identifier, for: indexPath) as! CreatAppointmentCollectionViewCell
        
        if let startTime = self.timeArray[indexPath.row].start {
            cell.timelbl.text = UtilityManager.stringFromNSDateWithFormat(date: startTime, format: "HH:mm a")
        }
       
        return cell
    }
    
 
}
