//
//  RxApplicationManager.swift
//  MyRxReminder
//
//  Created by Danial Zahid on 10/11/15.
//  Copyright © 2015 Danial Zahid. All rights reserved.
//

import UIKit

enum UserType : Int {
    case Doctor = 1
    case Patient = 2
}

class ApplicationManager {

    //MARK: - Shared Instance
    static let sharedInstance = ApplicationManager()
    
    //MARK: - Variable
    var user = User()
    var userType : UserType = UserType.Patient
    var token = ""
    
    
}
