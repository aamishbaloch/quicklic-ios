//
//  AppointmentsHistoryViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 30/08/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class AppointmentsHistoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    static let storyboardID = "appointmentsHistoryViewController"
    
    @IBOutlet weak var collectionView: UICollectionView!
     var appointmentsArray = [Appointment]()
     var date:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Appointments History"
        collectionView.delegate = self
        collectionView.dataSource = self
        
        fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        self.presentLeftMenuViewController(nil)
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
        
        if let startTime = self.appointmentsArray[indexPath.row].end_datetime {
            cell.timeLabel.text = UtilityManager.stringFromNSDateWithFormat(date: startTime as NSDate, format: "HH:mm a")
        }
     
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func fetchData() {
        
        var params = [String: Any]()
      
        if let endDate = date {
         params["end_date"] = endDate
        }
        RequestManager.getAppointments(params:params, successBlock: { (response) in
          //  self.appointmentsArray.removeAll()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
