//
//  TestDetailViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 27/11/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class TestDetailViewController: UIViewController {

    static let storyboardID = "testDetailViewController"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var starView: HCSStarRatingView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sampleLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    var test = Test()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = test.name
        
        nameLabel.text = test.name
        priceLabel.text = test.price
        starView.value = 0
        starView.isHidden = !(test.is_featured ?? false)
        starView.emptyStarColor = UIColor(hex: "FFC008")
        starView.tintColor = UIColor(hex: "FFC008")
        starView.starBorderColor = UIColor(hex: "FFC008")
        descriptionLabel.text = test.descriptionText
        sampleLabel.text = test.sample_required
        resultLabel.text = test.result_expectation

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
