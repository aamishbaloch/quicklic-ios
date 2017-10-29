//
//  AddClinicViewController.swift
//  Quicklic
//
//  Created by Danial Zahid on 29/10/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class AddClinicViewController: UIViewController {


    @IBOutlet weak var tf1: UITextField!
    @IBOutlet weak var tf2: UITextField!
    @IBOutlet weak var tf3: UITextField!
    @IBOutlet weak var tf4: UITextField!
    @IBOutlet weak var tf5: UITextField!
    @IBOutlet weak var tf6: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        tf1.becomeFirstResponder()
        title = "Add Clinic"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onDemoButtonPress(_ sender: Any) {
        if isCodeCompelte()
        {
            self.sendCodePostRequest(code: self.makeCode())
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

    // MARK: - Funcitons
    func setDelegates()
    {
        var tag = 1
        [tf1,tf2,tf3,tf4,tf5,tf6].forEach { (field) in
            field?.delegate = self
            field?.addTarget(self, action: #selector(self.textChanged(_:)), for: UIControlEvents.editingChanged)
            field?.tag = tag
            tag = tag + 1
        }
    }

    func textChanged(_ textField: UITextField)
    {
        if textField.text != ""
        {
            switch textField.tag {
            case 1:
                textField.resignFirstResponder()
                self.tf2.becomeFirstResponder()
                break
            case 2:
                textField.resignFirstResponder()
                self.tf3.becomeFirstResponder()
                break
            case 3:
                textField.resignFirstResponder()
                self.tf4.becomeFirstResponder()
                break
            case 4:
                textField.resignFirstResponder()
                self.tf5.becomeFirstResponder()
                break
            case 5:
                textField.resignFirstResponder()
                self.tf6.becomeFirstResponder()
                break
            case 6:
                textField.resignFirstResponder()
                if isCodeCompelte()
                {
                    self.sendCodePostRequest(code: self.makeCode())
                }
                break
            default:
                break
            }
        }
    }

    func isCodeCompelte() ->Bool
    {
        if self.tf1.text?.characters.count == 1{
            if self.tf2.text?.characters.count == 1{
                if self.tf3.text?.characters.count == 1{
                    if self.tf4.text?.characters.count == 1{
                        if self.tf5.text?.characters.count == 1{
                            if self.tf6.text?.characters.count == 1{
                                return true
                            }
                            else{
                                UtilityManager.turnTextFieldRed(textField: tf6)
                            }}
                        else{
                            UtilityManager.turnTextFieldRed(textField: tf5)
                        }}
                    else{
                        UtilityManager.turnTextFieldRed(textField: tf4)
                    }}
                else{
                    UtilityManager.turnTextFieldRed(textField: tf3)
                }}
            else{
                UtilityManager.turnTextFieldRed(textField: tf2)
            }}
        else{
            UtilityManager.turnTextFieldRed(textField: tf1)
        }
        return false
    }

    func makeCode() -> String
    {
        var code = self.tf1.text! + self.tf2.text! + self.tf3.text!
        code = code + self.tf4.text! + self.tf5.text! + self.tf6.text!
        return code
    }

    func sendCodePostRequest(code: String)
    {

        let params = ["code": code]
        SVProgressHUD.show(withStatus: "Adding")
        RequestManager.addClinic(params: params, successBlock: { (response) in
            SVProgressHUD.dismiss()
            Router.sharedInstance.showClinicsList()
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
        }
    }

}

extension AddClinicViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
