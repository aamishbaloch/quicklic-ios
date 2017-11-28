//
//  AddReviewViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 28/11/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class AddReviewViewController: UIViewController {

    static let storyboardID = "addReviewViewController"
   
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var starView: HCSStarRatingView!
    @IBOutlet weak var commentTextView: DesignableTextView!
    
    
    var appointment = Appointment()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("Doctor id \(String(describing: appointment.doctor.id))")
        print("clinic id \(String(describing: appointment.clinic.id))")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
       // var params = [String: AnyObject]()
        
        addReview()
        
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }

    func addReview(){
        var params = [String: Any]()
        let index  = segmentControl.selectedSegmentIndex + 1
        if index == 1 {
             params["doctor"] = appointment.doctor.id
        }else{
            params["clinic"] = appointment.clinic.id
            }
        params["type"] = index
        params["rating"] = starView.value
        params["comment"] = commentTextView.text
        params["is_anonymous"] = false
        print("StarView \(starView.value)")
        SVProgressHUD.show()
        RequestManager.addReview(params:params, successBlock: { (response) in

            SVProgressHUD.dismiss()
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
            print(error)
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
