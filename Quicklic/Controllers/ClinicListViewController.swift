//
//  ClinicListViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 27/10/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class ClinicListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, HospitalDeletionDelegate,UICollectionViewDelegateFlowLayout, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {

    static let storyboardID = "clinicListViewController"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var isLab = false
    
    var clinicArray = [Clinic]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        title = "Clinics"
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.emptyDataSetDelegate = self
        collectionView.emptyDataSetSource = self
        
        SVProgressHUD.show()
        fetchData()
        
        if !isLab {
            let barButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(ClinicListViewController.addButtonPressed(_:)))
            self.navigationItem.rightBarButtonItem = barButton
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchData() {
        
        if isLab {
            RequestManager.getLabsList(successBlock: { (response) in
                self.clinicArray.removeAll()
                for object in response {
                    self.clinicArray.append(Clinic(dictionary: object))
                }
                self.collectionView.reloadData()
                SVProgressHUD.dismiss()
            }, failureBlock: { (error) in
                SVProgressHUD.showError(withStatus: error)
            })
        }
        else{
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
        
        
        
        var text  = clinic.name! + ", " + clinic.location!
        text = text + "\n" + clinic.phone!
        
        cell.nameLabel.text = text
        cell.clinicImageView.sd_setImage(with: URL(string: clinic.image ?? ""), placeholderImage: UIImage(named: "user-image2"), options: [SDWebImageOptions.refreshCached, SDWebImageOptions.retryFailed], completed: nil)
        let floatValue : Float = NSString(string: clinic.rating!).floatValue
        cell.ratingView.value = CGFloat(floatValue)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isLab {
            Router.sharedInstance.showTests(clinic: clinicArray[indexPath.row], fromController: self)
        }
        else{
            Router.sharedInstance.showHospitalDetails(clinic: clinicArray[indexPath.row], fromController: self)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = self.collectionView.bounds.width
        
        return CGSize(width: cellWidth, height: 185)
    }
    
    
    func addButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "showAddClinic", sender: self)
    }
    
    func didDeleteClinic(withID: String) {
        fetchData()
    }
    
    //MARK : - EmptyDataSource Methods
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No Clinics Found"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center
        
        let attributes : [String: Any] = [NSFontAttributeName: UIFont(font: .Medium, size: 17.0) as Any,
                                          NSForegroundColorAttributeName: UIColor(red: 170.0/255.0, green: 171.0/255.0, blue: 179.0/255.0, alpha: 1.0),
                                          NSParagraphStyleAttributeName: paragraphStyle]
        return NSMutableAttributedString(string: text, attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Go ahead and add a new clinic by tapping on the + button on top right!"
        
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
//        return UIColor.clear
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

}
