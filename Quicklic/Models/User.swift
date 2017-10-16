//
//  User.swift
//  Quicklic
//
//  Created by Danial Zahid on 06/10/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

enum Gender: Int {
    case Male = 1, Female, Unknown
}

enum Role: Int {
    case Doctor = 1, Patient
}

enum MaritalStatus: Int {
    case Married = 1, Single
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
    var avatar: String?
    var first_name: String?
    var last_name: String?
    var email: String?
    var gender: Gender?
    var dob: NSDate?
    var address: String?
    var city: String?
    var country: String?
    var height: String?
    var weight: Int?
    var verified: Bool?
    var marital_status: MaritalStatus?
    
    override init() {
        super.init()
    }
    
    override init(dictionary: [AnyHashable : Any]!) {
        super.init()
        self.setValuesForKeysWithJSONDictionary(dictionary, dateFormatter: nil)
    }
}
