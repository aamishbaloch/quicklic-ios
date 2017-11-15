//
//  ReasonSelectionViewController.swift
//  Quicklic
//
//  Created by Furqan Nadeem on 11/14/17.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

protocol ReasonSelectionDelegate {
    func didSelectReason(reason:GenericModel)
}

class ReasonSelectionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    static let storyboardID = "reasonSelectionViewController"
    
    var reasons = [GenericModel]()
    
    
    
    @IBOutlet weak var reasonSelectionTable: UITableView!
     var delegate:ReasonSelectionDelegate?
     

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return reasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reasonSelectionTable.dequeueReusableCell(withIdentifier: ReasonSelectionTableViewCell.identifier, for: indexPath) as! ReasonSelectionTableViewCell
        
         cell.lblReason.text = reasons[indexPath.row].name
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.dismiss(animated: false) {
            self.delegate?.didSelectReason(reason: self.reasons[indexPath.row])
        }
    }
    
    func fetchData(searchString: String? = nil){
        
        var params = [String:String]()
        if let string = searchString {
            params["query"] = string
        }
        
        SVProgressHUD.show()
        RequestManager.getReasonsList(params: [:], successBlock: { (response) in
            SVProgressHUD.dismiss()
            self.reasons.removeAll()
            for object in response {
                self.reasons.append(GenericModel(dictionary: object))
            }
            self.reasonSelectionTable.reloadData()
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
