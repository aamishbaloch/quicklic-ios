//
//  AppointmentsHistoryViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 30/08/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class AppointmentsHistoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {

    static let storyboardID = "appointmentsHistoryViewController"
    
    @IBOutlet weak var collectionView: UICollectionView!
     var appointmentsArray = [Appointment]()
     var date:String?
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Appointments History"
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        
        refreshControl.addTarget(self, action: #selector(fetchData), for: UIControlEvents.valueChanged)
        collectionView.refreshControl = refreshControl
        
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
        return appointmentsArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DoctorAppointmentCollectionViewCell.identifier, for: indexPath) as! DoctorAppointmentCollectionViewCell
       
        let appointment = appointmentsArray[indexPath.item]
        
        if ApplicationManager.sharedInstance.userType == .Patient {
            cell.nameLabel.text = appointment.doctor.full_name
            
            cell.drImage.sd_setImage(with: URL(string: appointment.doctor.avatar ?? ""), placeholderImage: UIImage(named: "user-image2"), options: [SDWebImageOptions.refreshCached, SDWebImageOptions.retryFailed], completed: nil)
            cell.addReviewButton.isHidden = false
            cell.addReviewButton.addTarget(self, action: #selector(self.addReviewButtonPressed(_:)), for: UIControlEvents.touchUpInside)
            cell.addReviewButton.tag = indexPath.row
            
        }
        else{
            cell.nameLabel.text = appointment.patient.full_name
            
            cell.drImage.sd_setImage(with: URL(string: appointment.patient.avatar ?? ""), placeholderImage: UIImage(named: "user-image2"), options: SDWebImageOptions.refreshCached, completed: nil)
            cell.addReviewButton.isHidden = true
        }
        
        if let startTime = self.appointmentsArray[indexPath.row].start_datetime {
            cell.timeLabel.text = UtilityManager.stringFromNSDateWithFormat(date: startTime as NSDate, format: "hh:mm a MM-dd-yyyy")
        }
        
        cell.specializationLabel.text = appointment.reason.name
        
        let status = appointment.status?.value
        cell.statusLabel.text = status
        if status == "Confirmed"
        {
            cell.statusLabel.textColor = UIColor.green
        }else if status == "Pending" {
            cell.statusLabel.textColor = UIColor.orange
        }
        else if status == "Discard" || status == "Cancel" || status == "No Show" {
            cell.statusLabel.textColor = UIColor.red
        }
        else if status == "Done" {
            cell.statusLabel.textColor = .green
        }
        
        
     
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Router.sharedInstance.showAppointmentDetails(appointment: appointmentsArray[indexPath.item], appointmentIndex: indexPath.item, fromController: self)
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = self.collectionView.bounds.width
        return CGSize(width: cellWidth, height: 90)
    }
    
    
    
    func addReviewButtonPressed(_ sender: UIButton) {
        let appointment = appointmentsArray[sender.tag]
        Router.sharedInstance.addReview(appointment: appointment, fromController: self)
    }
    
    //MARK : - EmptyDataSource Methods
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "History not Found"
        
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
    
    
    func fetchData() {
        
        var params = [String: Any]()
        let date = Date(timeInterval: 86400, since: NSDate() as Date)
        params["end_date"] = UtilityManager.stringFromNSDateWithFormat(date: date as NSDate, format: "yyyy-MM-dd")
        
        SVProgressHUD.show()
        RequestManager.getAppointmentHistory(params:params, successBlock: { (response, nextPageLink) in
            self.appointmentsArray.removeAll()
            self.refreshControl.endRefreshing()
            self.processAPICallResponse(response: response, nextPageLink: nextPageLink)
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
        }
        
    }
    
    //MARK: - Pagination methods
    
    var nextPageLink: String?
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if nextPageLink != nil {
            if indexPath.row + 3 == appointmentsArray.count {
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
            self.appointmentsArray.append(Appointment(dictionary: object))
        }
        self.collectionView.reloadData()
        SVProgressHUD.dismiss()
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
