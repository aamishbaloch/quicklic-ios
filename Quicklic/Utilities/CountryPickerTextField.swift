//
//  PickerTextField.swift
//  MyRxReminder
//
//  Created by Danial Zahid on 11/30/15.
//  Copyright © 2015 Danial Zahid. All rights reserved.
//

import UIKit
import MRCountryPicker

class CountryPickerTextField: DesignableTextField, UITextFieldDelegate, MRCountryPickerDelegate {

    var pickerView: MRCountryPicker!
    var values : [String]?
    var selectedIndex : Int?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        pickerView = MRCountryPicker()
        let myInputView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: pickerView.frame.height+20))
        pickerView.frame = CGRect(x: pickerView.frame.origin.x, y: pickerView.frame.origin.y,width: myInputView.frame.size.width, height: pickerView.frame.size.height)
        pickerView.center = CGPoint(x: myInputView.center.x, y: myInputView.center.y + 10)
        myInputView.addSubview(pickerView)
        
        pickerView.countryPickerDelegate = self
        pickerView.showPhoneNumbers = true
        
        let locale = Locale.current
        if let code = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as? String {
            pickerView.setCountry(code)
        }
        
        
//        pickerView.maximumDate = NSDate() as Date
//        pickerView.datePickerMode = UIDatePickerMode.date
//        pickerView.addTarget(self, action: #selector(DatePickerTextField.pickerValueChanged), for: UIControlEvents.valueChanged)
        
        let donePickerBtn = UIButton(frame: CGRect(x:UIScreen.main.bounds.width - 80,y: 5,width: 50,height: 30))
        donePickerBtn.setTitle("Done", for: UIControlState.normal)
        donePickerBtn.setTitleColor(Styles.sharedStyles.primaryGreyColor, for: UIControlState.normal)
        donePickerBtn.addTarget(self, action: #selector(DatePickerTextField.donePickerBtnClick(sender:)), for: UIControlEvents.touchUpInside)
        myInputView.addSubview(donePickerBtn)
        
        self.inputView = myInputView
        self.delegate = self
        
        
        
    }
    
    
    //MARK: - Textfield delegates
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        self.text = UtilityManager.stringFromNSDateWithFormat(date: pickerView.date as NSDate, format: Constant.appDateFormat)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "datePickerTextFieldTextChanged"), object: nil)
    }
    
    //MARK: - IBActions
    
    @IBAction func donePickerBtnClick(sender: AnyObject){
//        self.text = pickerView.
        self.endEditing(true)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "datePickerTextFieldTextChanged"), object: nil)
    }
    
    func countryPhoneCodePicker(_ picker: MRCountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        self.text = phoneCode
    }
    
    
}
