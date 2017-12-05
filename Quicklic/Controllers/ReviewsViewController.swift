//
//  ReviewsViewController.swift
//  Quicklic
//
//  Created by Furqan Nadeem on 11/28/17.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class ReviewsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {
   
    static let storyboardID = "reviewsViewController"
    
    var reviews = [Review]()
    
    @IBOutlet weak var collectoinView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Reviews"

        // Do any additional setup after loading the view.
        collectoinView.dataSource = self
        collectoinView.delegate = self
        collectoinView.emptyDataSetSource = self
        collectoinView.emptyDataSetDelegate = self
        print("hashkdasjdkasdjaskdjaskdjsalfas")
          self.fetchData()
       //print("Doctor id thorough apointment \(String(describing: appointment.doctor.id))")
       // print("Doctor id \(doctor?.id)")
        
        if let flowLayout = collectoinView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCollectionViewCell.identifier, for: indexPath) as! ReviewCollectionViewCell
        
        let review = reviews[indexPath.row]
        
        guard let type = review.type else {
            return cell
        }
        
        switch type {
        case 1:
            cell.nameLabel.text = review.doctor.full_name ?? "N/A"
            cell.imageView.sd_setImage(with: URL(string: review.doctor.avatar ?? ""), placeholderImage: UIImage(named: "placeholder-image"), options: .refreshCached, completed: nil)
        case 2:
            cell.nameLabel.text = review.clinic.name ?? "N/A"
            cell.imageView.sd_setImage(with: URL(string: review.clinic.image ?? ""), placeholderImage: UIImage(named: "placeholder-image"), options: .refreshCached, completed: nil)
        default: break
        }
        
        cell.descriptionLabel.text = review.comment ?? "N/A"
        cell.dateLabel.text = UtilityManager.stringFromNSDateWithFormat(date: review.created_at! as NSDate, format: Constant.appDateFormat)
        cell.ratingView.value = CGFloat(review.rating!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
    
//    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let cellWidth = self.collectoinView.bounds.width
//        
//        return CGSize(width: cellWidth, height: 90)
//    }
    
    @IBAction func menuButtonPressed(_ sender: UIBarButtonItem) {
         self.presentLeftMenuViewController(nil)
    }
    
    func fetchData() {
        
        SVProgressHUD.show()
        
        RequestManager.getReviews(successBlock: { (response) in
            SVProgressHUD.dismiss()
            self.reviews.removeAll()
            for review in response {
                self.reviews.append(Review(dictionary: review))
            }
            self.collectoinView.reloadData()
            
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
        }
        
    }
    
    //MARK : - EmptyDataSource Methods
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No Reviews Found"
        
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
   

}
