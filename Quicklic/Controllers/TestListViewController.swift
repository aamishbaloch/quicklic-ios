//
//  TestListViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 27/11/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class TestListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    static let storyboardID = "testListViewController"

    @IBOutlet weak var clinicImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starView: HCSStarRatingView!
    @IBOutlet weak var tableView: UITableView!
    
    var clinic = Clinic()
    var tests = [Test]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Tests"

        var text  = clinic.name! + ", " + clinic.location!
        text = text + "\n" + clinic.phone!
        
        nameLabel.text = text
        clinicImageView.sd_setImage(with: URL(string: clinic.image ?? ""), placeholderImage: UIImage(named: "placeholdernew"), options: SDWebImageOptions.refreshCached, completed: nil)
        let floatValue : Float = NSString(string: clinic.rating!).floatValue
        starView.value = CGFloat(floatValue)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        SVProgressHUD.show()
        RequestManager.getTestsList(clinicID: clinic.id ?? "", successBlock: { (response) in
            self.tests.removeAll()
            for object in response {
                self.tests.append(Test(dictionary: object))
            }
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TestListTableViewCell.identifier) as! TestListTableViewCell
        
        let test = tests[indexPath.row]
        
        cell.nameLabel.text = test.name
        cell.priceLabel.text = test.price
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Router.sharedInstance.showTestDetail(test: tests[indexPath.row], fromController: self)
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
