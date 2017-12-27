//
//  NotificationListViewController.swift
//  Quicklic
//
//  Created by Furqan Nadeem on 12/27/17.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class NotificationListViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

   static let storyboardID = "NotificationListViewController"
    
    var notificationArray = [NotificationL]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        notificationData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        self.presentLeftMenuViewController(nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // return notificationArray.count
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificationCollectionViewCell.identifier, for: indexPath) as! NotificationCollectionViewCell
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        Router.sharedInstance.showAppointmentDetails(appointment: self.appointmentsArray[indexPath.item],appointmentIndex: indexPath.item, fromController: self)
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = self.collectionView.bounds.width
        
        return CGSize(width: cellWidth, height: 90)
    }
    
    func notificationData() {
        
//        var params = [String: Any]()
//        if let date = selectedDate {
//            params["start_date"] = date
//            params["end_date"] = date
//        }
       
        RequestManager.getNotificationList(params:[:], successBlock: { (response) in
           self.notificationArray.removeAll()
            for object in response {
                self.notificationArray.append(NotificationL(dictionary: object))
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
