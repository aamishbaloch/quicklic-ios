//
//  CreateAppointmentViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 01/11/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class CreateAppointmentViewController: UIViewController{

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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        SVProgressHUD.show()
        RequestManager.getReasonsList(params: [:], successBlock: { (response) in
            SVProgressHUD.dismiss()
            self.reasons.removeAll()
            for object in response {
                self.reasons.append(GenericModel(dictionary: object))
            }
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
        }
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func reasonButtonPressed(_ sender: Any) {
        
    }
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil)
    }
    

}
