//
//  ReviewsViewController.swift
//  Quicklic
//
//  Created by Furqan Nadeem on 11/28/17.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class ReviewsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    static let storyboardID = "reviewsViewController"
    
  //var appointment:Appointment!
  //var doctor = User()
    
    @IBOutlet weak var collectoinView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectoinView.dataSource = self
        collectoinView.delegate = self
        print("hashkdasjdkasdjaskdjaskdjsalfas")
          self.fetchData()
       //print("Doctor id thorough apointment \(String(describing: appointment.doctor.id))")
       // print("Doctor id \(doctor?.id)")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCollectionViewCell.identifier, for: indexPath) as! ReviewCollectionViewCell
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = self.collectoinView.bounds.width
        
        return CGSize(width: cellWidth, height: 90)
    }
    
    @IBAction func menuButtonPressed(_ sender: UIBarButtonItem) {
         self.presentLeftMenuViewController(nil)
    }
    
    
    func fetchData() {
    
//        guard let doctorID = doctor?.id else {
//            return
//        }
        // print("Doctor id \(doctorID)")
        SVProgressHUD.show()
        
        RequestManager.doctorsReview(doctorID:"12", successBlock: { (response) in
            SVProgressHUD.dismiss()
            print("Calling..")
            
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
