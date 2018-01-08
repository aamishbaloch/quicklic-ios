//
//  VisitListViewController.swift
//  Quicklic
//
//  Created by Furqan Nadeem on 12/7/17.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class VisitListViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,AppointmentStatusDelegate {
    
   
    
    static let storyboardID = "VisitListViewController"
    @IBOutlet weak var collectionView: UICollectionView!
    
    var visitArray = [Appointment]()
    var appointment = Appointment()
    var statusIs:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "Visits"
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        
        collectionView.reloadData()
        
        SVProgressHUD.show()
        fetchData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func appointmenConfirmation(status: AppointmentStatus, index: Int) {
        visitArray[index].status = status
        collectionView.reloadData()
        fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func menubuttonPressed(_ sender: UIBarButtonItem) {
         self.presentLeftMenuViewController(nil)
    }
    
    func fetchData() {
        
        guard let doctorId = ApplicationManager.sharedInstance.user.id  else {return}
        print("Doctor id: \(doctorId)")
        RequestManager.getVisitList(doctorID:doctorId, params: [:],successBlock: { (response) in
            SVProgressHUD.dismiss()
            self.visitArray.removeAll()
            for object in response {
                self.visitArray.append(Appointment(dictionary: object))
            }
            
            self.collectionView.reloadData()
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visitArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VisitCollectionViewCell.identifier, for: indexPath) as! VisitCollectionViewCell
        
        let visit  = visitArray[indexPath.row]
        cell.nameLabel.text = visit.patient.full_name
      //print("Name is:\(visit.doctor.full_name)")
        cell.imageView.sd_setImage(with: URL(string: visit.patient.avatar ?? ""), placeholderImage: UIImage(named: "placeholder-image"), options: [SDWebImageOptions.refreshCached, SDWebImageOptions.retryFailed], completed: nil)
        if let startTime = self.visitArray[indexPath.row].start_datetime {
            cell.timeLabel.text = UtilityManager.stringFromNSDateWithFormat(date: startTime as NSDate, format: "hh:mm a")
        }
        
        let status = visit.status?.value
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
        else if status == "Cancel" {
            cell.statusLabel.textColor = UIColor.red
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Router.sharedInstance.showAppointmentDetailsForVisit(appointment: self.visitArray[indexPath.item],appointmentIndex: indexPath.item, fromController: self)
    }
    
    //MARK : - EmptyDataSource Methods
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No Visits Found"
        
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
