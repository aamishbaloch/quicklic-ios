//
//  NotificationListViewController.swift
//  Quicklic
//
//  Created by Furqan Nadeem on 12/27/17.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class NotificationListViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    static let storyboardID = "NotificationListViewController"
    
    var notificationArray = [NotificationObject]()
    var nextPageLink: String?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        fetchData()
        
        title = "Notifications"
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        self.presentLeftMenuViewController(nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notificationArray.count
        //        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificationCollectionViewCell.identifier, for: indexPath) as! NotificationCollectionViewCell
        let notification = notificationArray[indexPath.item]
        
        cell.nameLabel.text = notification.heading
        cell.contentLabel.text = notification.content
        if let creationdate = notification.created_at as NSDate? {
            cell.timeLabel.text = UtilityManager.timeAgoSinceDate(date: creationdate, numericDates: true)
        }
        if let isRead = notification.is_read {
            if isRead {
                cell.mainView.backgroundColor = UIColor.white
            }
            else{
                cell.mainView.backgroundColor = UIColor(red: 219.0/255.0, green: 245.0/255.0, blue: 253.0/255.0, alpha: 1.0)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Router.sharedInstance.showAppointmentDetails(appointment: self.notificationArray[indexPath.item].appointment!,appointmentIndex: indexPath.item, fromController: self)
        notificationArray[indexPath.row].is_read = true
        self.collectionView.reloadData()
        RequestManager.markNotificationRead(notificationID: notificationArray[indexPath.row].id ?? "0", params: [:], successBlock: { (response) in
            
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = self.collectionView.bounds.width
        
        return CGSize(width: cellWidth, height: 90)
    }
    
    func fetchData() {
        
        RequestManager.getNotificationList(params:[:], successBlock: { (response) in
            self.notificationArray.removeAll()
            for object in response {
                self.notificationArray.append(NotificationObject(dictionary: object))
                print("Array is : \(object)")
            }
            self.collectionView.reloadData()
            SVProgressHUD.dismiss()
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: error)
        }
        
    }
    
    func pagination() {
        
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
