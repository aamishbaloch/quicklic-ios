//
//  NotificationListViewController.swift
//  Quicklic
//
//  Created by Furqan Nadeem on 12/27/17.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class NotificationListViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {
    
    static let storyboardID = "NotificationListViewController"
    
    var notificationArray = [NotificationObject]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        SVProgressHUD.show()
        fetchData()
        
        title = "Notifications"
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        
        refreshControl.addTarget(self, action: #selector(fetchData), for: UIControlEvents.valueChanged)
        collectionView.refreshControl = refreshControl
        
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
        
        if notification.type == 1 {
            let image = ApplicationManager.sharedInstance.userType == .Patient ? notification.appointment?.doctor.avatar ?? "" : notification.appointment?.patient.avatar ?? ""
            cell.imageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "user-image-done"), options: [SDWebImageOptions.refreshCached, SDWebImageOptions.retryFailed], completed: nil)
            cell.nameLabel.text = notification.content
        }
        else{
            cell.imageView.image = UIImage(named: "announcement-icon")
            cell.nameLabel.text = notification.content
        }
        
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
        if notificationArray[indexPath.item].type == 1 {
            Router.sharedInstance.showAppointmentDetails(appointment: self.notificationArray[indexPath.item].appointment!,appointmentIndex: indexPath.item, fromController: self)
            notificationArray[indexPath.row].is_read = true
            self.collectionView.reloadData()
            RequestManager.markNotificationRead(notificationID: notificationArray[indexPath.row].id ?? "0", params: [:], successBlock: { (response) in
                
            }) { (error) in
                SVProgressHUD.showError(withStatus: error)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = self.collectionView.bounds.width
        
        return CGSize(width: cellWidth, height: 90)
    }
    
    @IBAction func markAllNotificationsRead(_ sender: Any) {
        SVProgressHUD.show()
        RequestManager.markAllNotifcationsRead(successBlock: { (response) in
            self.fetchData()
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
        }
    }
    
    
    func fetchData() {
        
        RequestManager.getNotificationList(params:[:], successBlock: { (response, nextPageLink) in
            self.refreshControl.endRefreshing()
            self.notificationArray.removeAll()
            self.processAPICallResponse(response: response, nextPageLink: nextPageLink)
            
        }) { (error) in
            
            SVProgressHUD.showError(withStatus: error)
        }
        
    }
    
    
    var nextPageLink: String?
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if nextPageLink != nil {
            if indexPath.row + 3 == notificationArray.count {
                fetchPagination()
            }
        }
    }
    
    func fetchPagination() {
        
        if let link = nextPageLink {
            RequestManager.getPaginationResponse(url: link, successBlock: { (response, nextPageLink) in
                self.processAPICallResponse(response: response, nextPageLink: nextPageLink)
            }, failureBlock: { (error) in
                SVProgressHUD.showError(withStatus: error)
            })
        }
    }
    
    func processAPICallResponse(response: [[String: AnyObject]], nextPageLink : String?) {
        self.nextPageLink = nextPageLink
        for object in response {
            self.notificationArray.append(NotificationObject(dictionary: object))
        }
        self.collectionView.reloadData()
        SVProgressHUD.dismiss()
    }
    
    
    //MARK : - EmptyDataSource Methods
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No Notifications Found"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center
        
        let attributes : [String: Any] = [NSFontAttributeName: UIFont(font: .Medium, size: 17.0) as Any,
                                          NSForegroundColorAttributeName: UIColor(red: 170.0/255.0, green: 171.0/255.0, blue: 179.0/255.0, alpha: 1.0),
                                          NSParagraphStyleAttributeName: paragraphStyle]
        return NSMutableAttributedString(string: text, attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = ""
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center
        
        let attributes : [String: Any] = [NSFontAttributeName: UIFont(font: .Standard, size: 15.0) as Any,
                                          NSForegroundColorAttributeName: UIColor(red: 170.0/255.0, green: 171.0/255.0, blue: 179.0/255.0, alpha: 1.0),
                                          NSParagraphStyleAttributeName: paragraphStyle]
        return NSMutableAttributedString(string: text, attributes: attributes)
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let text = "Reload"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center
        
        var color: UIColor!
        
        if state == .normal {
            color = UIColor(red: 44.0/255.0, green: 137.0/255.0, blue: 202.0/255.0, alpha: 1.0)
        }
        if state == .highlighted {
            color = UIColor(red: 106.0/255.0, green: 187.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        }
        
        let attributes : [String: Any] = [NSFontAttributeName: UIFont(font: .SemiBold, size: 14.0) as Any,
                                          NSForegroundColorAttributeName: color,
                                          NSParagraphStyleAttributeName: paragraphStyle]
        return NSMutableAttributedString(string: text, attributes: attributes)
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor(white: 1.0, alpha: 1.0)
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return false
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        SVProgressHUD.show()
        fetchData()
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        SVProgressHUD.show()
        fetchData()
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
