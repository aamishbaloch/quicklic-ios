//
//  ClinicListViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 27/10/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class ClinicListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, HospitalDeletionDelegate,UICollectionViewDelegateFlowLayout {

    static let storyboardID = "clinicListViewController"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var clinicArray = [Clinic]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        title = "Clinics"
        collectionView.delegate = self
        collectionView.dataSource = self
        
        SVProgressHUD.show()
        fetchData()
        
        let barButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(ClinicListViewController.addButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchData() {
        
        RequestManager.getClinicsList(successBlock: { (response) in
            self.clinicArray.removeAll()
            for object in response {
                self.clinicArray.append(Clinic(dictionary: object))
            }
            self.collectionView.reloadData()
            SVProgressHUD.dismiss()
            
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
        }
    
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        self.presentLeftMenuViewController(nil)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.clinicArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClinicCollectionViewCell.identifier, for: indexPath) as! ClinicCollectionViewCell
        
        let clinic = self.clinicArray[indexPath.row]
        let clinicName = clinic.name
        let clinicAddress = clinic.location
        
        
        cell.nameLabel.text = clinicName! + "," + clinicAddress!
        cell.clinicImageView.sd_setImage(with: URL(string: clinic.image ?? ""), placeholderImage: UIImage(named: "placeholder-image"), options: SDWebImageOptions.refreshCached, completed: nil)
       // cell.phoneLabel.text = clinic.phone
      //  cell.locationLabel.text = clinicName! + "," + clinicAddress!
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        Router.sharedInstance.showHospitalDetails(clinic: clinicArray[indexPath.row], fromController: self)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width
        
        return CGSize(width: cellWidth, height: 185)
    }
    
    
    func addButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "showAddClinic", sender: self)
    }
    
    func didDeleteClinic(withID: String) {
        fetchData()
    }

}
