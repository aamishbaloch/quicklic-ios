//
//  HospitalDetailsViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 18/09/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

protocol HospitalDeletionDelegate {
    func didDeleteClinic(withID: String)
}

class HospitalDetailsViewController: UIViewController {
    
    static let storyboardID = "hospitalDetailsViewController"

    @IBOutlet weak var clinicImageView: DesignableImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    var delegate: HospitalDeletionDelegate?
    var clinic: Clinic!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        titleLabel.text = clinic.name
        clinicImageView.sd_setImage(with: URL(string: clinic.image ?? ""), placeholderImage: UIImage(named: "user-image2"), options: SDWebImageOptions.refreshCached, completed: nil)
        phoneLabel.text = clinic.phone
        locationLabel.text = clinic.location
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }

    @IBAction func deleteButtonPressed(_ sender: Any) {
        
        UIAlertController.showAlert(in: self, withTitle: "Confirmation", message: "Are you sure you want to remove this clinic?", cancelButtonTitle: "No", destructiveButtonTitle: "Delete", otherButtonTitles: []) { (alertController, alertAction, buttonIndex) in
            if buttonIndex == alertController.destructiveButtonIndex {
                SVProgressHUD.show()
                RequestManager.deleteClinic(clinicID: self.clinic.id!, successBlock: { (response) in
                    SVProgressHUD.dismiss()
                    self.delegate?.didDeleteClinic(withID: self.clinic.id!)
                    self.dismiss(animated: false, completion: nil)
                }) { (error) in
                    SVProgressHUD.showError(withStatus: error)
                }
            }
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
