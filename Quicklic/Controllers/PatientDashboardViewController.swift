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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Dashboard"
        
        setupDatePicker()
        collectionView.delegate = self
        collectionView.dataSource = self
        
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
    
    
    @IBAction func hospitalDetailsButtonPressed(_ sender: Any) {
        Router.sharedInstance.showHospitalDetails(fromController: self)
    }
    
    func datepicker(_ datepicker: ScrollableDatepicker, didSelectDate date: Date) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DoctorAppointmentCollectionViewCell.identifier, for: indexPath) as! DoctorAppointmentCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Router.sharedInstance.showAppointmentDetails(fromController: self)
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
