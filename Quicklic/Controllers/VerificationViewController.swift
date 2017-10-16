//
//  VerificationViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 15/10/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class VerificationViewController: UIViewController {

    static let storyboardID = "verificationViewController"
    
    @IBOutlet weak var phoneField: DesignableTextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func verifyButtonPressed(_ sender: Any) {
        let params = ["code":phoneField.text]
        RequestManager.verifyUser(param: params, successBlock: { (response) in
            Router.sharedInstance.showDashboardAsRoot()
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
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
