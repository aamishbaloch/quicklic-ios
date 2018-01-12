//
//  PatientsListViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 18/09/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class PatientsListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {

    static let storyboardID = "patientsListViewController"
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    var paitentArray = [User]()
    var appointment = Appointment()
    
    let refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        title = "Patients"
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
        return paitentArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PatientCollectionViewCell.identifier, for: indexPath) as! PatientCollectionViewCell
        
        let paitent = paitentArray[indexPath.row]
        cell.imageView.sd_setImage(with: URL(string: paitent.avatar ?? ""), placeholderImage: UIImage(named: "user-image2"), options: [SDWebImageOptions.refreshCached, SDWebImageOptions.retryFailed], completed: nil)
        cell.nameLabel.text = paitent.full_name ?? "N/A"
        cell.phoneLabel.text = paitent.phone ?? "N/A"
    
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
        Router.sharedInstance.showOtherProfile(user: paitentArray[indexPath.item], fromController: self)
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = self.collectionView.bounds.width
        
        return CGSize(width: cellWidth-5, height: 95)
    }

    
    func fetchData(){
        
        let params = [String: Any]()
   
        SVProgressHUD.show()
        RequestManager.getPatientsList(params: params, successBlock: { (response, nextPageLink) in
            self.paitentArray.removeAll()
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
            if indexPath.row + 3 == paitentArray.count {
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
            self.paitentArray.append(User(dictionary: object))
        }
        self.collectionView.reloadData()
        SVProgressHUD.dismiss()
    }
    
    
    //MARK : - EmptyDataSource Methods
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No Patients Found"
        
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
