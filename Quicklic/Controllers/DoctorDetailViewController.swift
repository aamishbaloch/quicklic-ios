//
//  DoctorDetailViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 01/11/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

protocol DoctorDetailDelegate {
    func didPressAppointmentButtion(doctor: User)
}

class DoctorDetailViewController: UIViewController {

    static let storyboardID = "doctorDetailViewController"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: DesignableImageView!
    @IBOutlet weak var specialityLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var educationLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    @IBOutlet weak var patientsSeenLabel: UILabel!
    
    var doctor: User!
    
    var delegate: DoctorDetailDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("Doctor id:\(String(describing: doctor.id))")
        nameLabel.text = doctor.full_name ?? "N/A"
        profileImageView.sd_setImage(with: URL(string: doctor.thumb ?? ""), placeholderImage: UIImage(named: "user-image2"), options: [SDWebImageOptions.refreshCached, SDWebImageOptions.retryFailed], completed: nil)
        specialityLabel.text = doctor.specializationName ?? "N/A"
        phoneLabel.text = doctor.phone ?? "N?A"
        educationLabel.text = doctor.degree ?? "N/A"
        serviceLabel.text = doctor.servicesArray.joined(separator: ", ").length > 0 ? doctor.servicesArray.joined(separator: ", ") : "N/A"
        let floatValue : Float = NSString(string: doctor.rating!).floatValue
        ratingView.value = CGFloat(floatValue)
        patientsSeenLabel.text = doctor.patients_seen ?? "0"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func scheduleAppointmentButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: false) {
            self.delegate?.didPressAppointmentButtion(doctor: self.doctor)
        }
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
