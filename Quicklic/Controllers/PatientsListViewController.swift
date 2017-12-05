//
//  PatientsListViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 18/09/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class PatientsListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    static let storyboardID = "patientsListViewController"
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    var paitentArray = [User]()
    var appointment = Appointment()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        title = "Patients"
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
        return paitentArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PatientCollectionViewCell.identifier, for: indexPath) as! PatientCollectionViewCell
        
        let paitent = paitentArray[indexPath.row]
        cell.imageView.sd_setImage(with: URL(string: paitent.avatar ?? ""), placeholderImage: UIImage(named: "user-image2"), options: [SDWebImageOptions.refreshCached, SDWebImageOptions.retryFailed], completed: nil)
        cell.nameLabel.text = paitent.full_name ?? "N/A"
        cell.phoneLabel.text = paitent.phone ?? "N/A"
        cell.addressLabel.text = paitent.address ?? "N/A"
        cell.emailLabel.text = paitent.email ?? "N/A"
    
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
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

    
    func fetchData(){
        
        var params = [String: Any]()
   
        SVProgressHUD.show()
        RequestManager.getPatientsList(params: params, successBlock: { (response) in
            self.paitentArray.removeAll()
            for object in response {
               self.paitentArray.append(User(dictionary: object))
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
