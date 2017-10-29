//
//  User.swift
//  Quicklic
//
//  Created by Danial Zahid on 06/10/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

enum Gender: Int {
    case Male = 1, Female, Unknown
    
    var value : String {
        switch self {
        case .Male:
            return "Male"
        case .Female:
            return "Female"
        case .Unknown:
            return "Unknown"
        }
    }
}

enum Role: Int {
    case Doctor = 1, Patient
    
    var value : String {
        switch self {
        case .Doctor:
            return "Doctor"
        case .Patient:
            return "Patient"
        }
    }
}

enum MaritalStatus: Int {
    case Married = 1, Single
    
    var value : String {
        switch self {
        case .Married:
            return "Married"
        case .Single:
            return "Single"
        }
    }
}

import UIKit

class User: BaseEntity {
    
    /*{
     message = "<null>";
     response =     {
     address = "<null>";
     avatar = "<null>";
     city = "<null>";
     country = "<null>";
     dob = "<null>";
     email = "<null>";
     "first_name" = Aamish;
     gender = 3;
     height = "<null>";
     id = 16;
     "last_name" = Baloch;
     "marital_status" = "<null>";
     occupation = "<null>";
     phone = 1234567896;
     role = 2;
     token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJwaG9uZSI6IjEyMzQ1Njc4OTYiLCJleHAiOjE1MDg2NzE2NzR9.o4cQkFFnlFHUqeral-78DBz5gH3l-gDwkeaXxRIsiPQ";
     verified = 0;
     weight = "<null>";
     };
     }
*/

    var id: String?
    var userType : UserType?
    var avatar: String?
    var first_name: String?
    var last_name: String?
    var full_name: String?
    var role: UserType?
    var phone: String?
    var email: String?
    var gender: Gender?
    var dob: NSDate?
    var address: String?
    var cityName: String?
    var countryName: String?
    var verified: Bool?
    
    //Patient variables
    var height: String?
    var weight: String?
    var marital_status: MaritalStatus?
    var occupationName: String?
    
    //Doctor variables
    var servicesArray = [String]()
    var specializationName : String?
    var degree: String?
    
    override init() {
        super.init()
    }
    
    override init(dictionary: [AnyHashable : Any]!) {
        super.init()
        self.setValuesForKeysWithJSONDictionary(dictionary, dateFormatter: nil)
        self.role = UserType(rawValue: dictionary["role"] as? Int ?? 1)
        self.cityName = (dictionary["city"] as? [String: AnyObject])?["name"] as? String ?? nil
        self.countryName = (dictionary["country"] as? [String: AnyObject])?["name"] as? String ?? nil
        self.occupationName = (dictionary["occupation"] as? [String: AnyObject])?["name"] as? String ?? nil
        self.marital_status = MaritalStatus(rawValue: dictionary["marital_status"] as? Int ?? 1)
        self.userType = UserType(rawValue: dictionary["role"] as? Int ?? 1)
        self.gender = Gender(rawValue:  dictionary["gender"] as? Int ?? 1)
        self.full_name = "\(first_name ?? "") \(last_name ?? "")"
        if let date = dictionary["dob"] as? String {
            self.dob = UtilityManager.dateFromStringWithFormat(date:  date, format: Constant.serverDateFormat)
        }
        
        if let services = dictionary["services"] as? [[String: AnyObject]] {
            for service in services {
                if let name = service["name"] as? String {
                    self.servicesArray.append(name)
                }
                
            }
        }
        self.specializationName = (dictionary["specialization"] as? [String: AnyObject])?["name"] as? String ?? nil
        
        
        
    }
}
