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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        var params = [String: AnyObject]()
        
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
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
