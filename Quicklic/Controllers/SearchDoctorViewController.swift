//
//  SearchDoctorViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 30/08/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class SearchDoctorViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, DoctorDetailDelegate {

    static let storyboardID = "searchDoctorViewController"
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchField: DesignableTextField!
    
    var doctorsArray = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "Select Doctor"
        collectionView.delegate = self
        collectionView.dataSource = self
        
        searchField.delegate = self
//        searchField.addTarget(self, action: #selector(self.searchFieldValueChanged(_:)), for: .)
        
        SVProgressHUD.show()
        fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchData(searchString: String? = nil) {
        
        var params = [String:String]()
        if let string = searchString {
            params["query"] = string
        }
        
        RequestManager.getDoctorsList(params: params, successBlock: { (response) in
            self.doctorsArray.removeAll()
            for object in response {
                self.doctorsArray.append(User(dictionary: object))
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
        return self.doctorsArray.count
//        return self.doctorsArray.count == 0 ? 0 : 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchDoctorCollectionViewCell.identifier, for: indexPath) as! SearchDoctorCollectionViewCell
        
        let user = self.doctorsArray[indexPath.row]
        
        cell.nameLabel.text = user.full_name
        cell.profileImageView.sd_setImage(with: URL(string: user.avatar ?? ""), placeholderImage: UIImage(named: "placeholder-image"), options: SDWebImageOptions.refreshCached, completed: nil)
        cell.specializationLabel.text = user.specializationName
        cell.phoneLabel.text = user.phone
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Router.sharedInstance.showDoctorDetails(doctor: self.doctorsArray[indexPath.row], fromController: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
  
    @IBAction func searchFieldValueChanged(_ sender: Any) {
        fetchData(searchString: searchField.text)
        
    }
    
    func didPressAppointmentButtion(doctor: User) {
        Router.sharedInstance.createAppointment(doctor: doctor, fromController: self)
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
