//
//  ConfirmationViewController.swift
//  Quicklic
//
//  Created by Furqan Nadeem on 11/28/17.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class ConfirmationViewController: UIViewController {

    static let storyboardID = "confirmationViewController"
    
    @IBOutlet weak var confirmationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var appointment:Appointment!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let startTime = appointment.start_datetime {
            timeLabel.text = UtilityManager.stringFromNSDateWithFormat(date: startTime as NSDate, format: "hh:mm a")
            print("startTime \(startTime)")
        }
        
        dateLabel.text = UtilityManager.stringFromNSDateWithFormat(date:appointment.start_datetime! as NSDate , format: Constant.appDateFormat)
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func finishButton(_ sender: Any) {
        Router.sharedInstance.showPatientDashboard()
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
