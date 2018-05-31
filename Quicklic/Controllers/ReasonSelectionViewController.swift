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
    func didSelectClinic(clinic: Clinic)
}

class ReasonSelectionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    static let storyboardID = "reasonSelectionViewController"
    
    var reasons = [GenericModel]()
    var clinics = [Clinic]()
    var isClinic = false
    
    @IBOutlet weak var reasonSelectionTable: UITableView!
    var delegate:ReasonSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Select Reason"
        
        setupNav()
        if !isClinic {
            fetchData()
        }
        else{
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNav() {
        let leftButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelButtonPressed))
        navigationItem.leftBarButtonItem = leftButton
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isClinic {
            return reasons.count
        }
        else{
            return clinics.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reasonSelectionTable.dequeueReusableCell(withIdentifier: ReasonSelectionTableViewCell.identifier, for: indexPath) as! ReasonSelectionTableViewCell
        
        if !isClinic {
            cell.lblReason.text = reasons[indexPath.row].name
        }
        else{
            cell.lblReason.text = clinics[indexPath.row].name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.dismiss(animated: true) {
            if !self.isClinic {
                self.delegate?.didSelectReason(reason: self.reasons[indexPath.row])
            }
            else{
                self.delegate?.didSelectClinic(clinic: self.clinics[indexPath.row])
            }
            
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
    
    func cancelButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
}
