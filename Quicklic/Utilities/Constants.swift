//
//  Constants.swift
//  Quicklic
//
//  Created by Danial Zahid on 30/07/2015.
//  Copyright (c) 2015 Danial Zahid. All rights reserved.
//

import UIKit

public class Constant: NSObject {

    static let applicationName = "Quicklic"
    static let serverDateFormat = "yyyy-MM-dd"
    static let serverDateFormatExtended = "yyyy-MM-dd'T'hh:mm:ss.SSS"
    static let appDateFormat = "MM/dd/yyyy"
    static let appAppointmentDateFormat = "MMM dd',' yyyy"
    static let animationDuration : TimeInterval = 0.5
    
    static let serverURL = "http://staging.quicklic.com/api/v1/"
//    static let serverURL = "http://5fef7a8c.ngrok.io/api/v1/"
    
    static let mainColor = UIColor(red: 145.0/255.0, green: 20.0/255.0, blue: 217.0/255.0, alpha: 1.0)
    
    
    //MARK: - Response Keys
    
    static let messageKey = "message"
    static let responseKey = "response"
    static let successKey = "success"
    
    //MARK: - URL keys
    
    static let registrationURL = "auth/register/"
    static let loginURL = "auth/login/"
    
    
}
