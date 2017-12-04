//
//  SearchDoctorViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 30/08/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class SearchDoctorViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, DoctorDetailDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {

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
        
        collectionView.emptyDataSetDelegate = self
        collectionView.emptyDataSetSource = self
        
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
        cell.profileImageView.sd_setImage(with: URL(string: user.avatar ?? ""), placeholderImage: UIImage(named: "user-image2"), options: SDWebImageOptions.refreshCached, completed: nil)
        cell.specializationLabel.text = user.specializationName
        cell.phoneLabel.text = user.phone
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Router.sharedInstance.showDoctorDetails(doctor: self.doctorsArray[indexPath.row], fromController: self)
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width
        
        return CGSize(width: cellWidth, height: CGFloat(90))
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
    
    
    
    //MARK : - EmptyDataSource Methods
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No Doctors Found"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center
        
        let attributes : [String: Any] = [NSFontAttributeName: UIFont(font: .Medium, size: 17.0) as Any,
                                          NSForegroundColorAttributeName: UIColor(red: 170.0/255.0, green: 171.0/255.0, blue: 179.0/255.0, alpha: 1.0),
                                          NSParagraphStyleAttributeName: paragraphStyle]
        return NSMutableAttributedString(string: text, attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Please ask your respective clinic to add their doctors to Quicklic"
        
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
