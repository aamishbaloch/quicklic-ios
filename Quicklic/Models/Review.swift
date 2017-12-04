//
//  Review.swift
//  Quicklic
//
//  Created by Danial Zahid on 02/12/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class Review: BaseEntity {
    
    
    var id:String?
    var name:String?
    var clinic = Clinic()
    var doctor = User()
    var creator = User()
    var type : Int?
    var comment : String?
    var rating: Int?
    var created_at:Date?
    var is_anonymous: Bool?
    
    
    override init() {
        super.init()
    }
    
    override init(dictionary: [AnyHashable : Any]!) {
        super.init()
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = Constant.serverDateFormatExtended
        //        newDateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        self.setValuesForKeysWithJSONDictionary(dictionary, dateFormatter: newDateFormatter)
        if let clinicObject = dictionary["clinic"] as? [String: AnyObject] {
            self.clinic = Clinic(dictionary: clinicObject)
        }
        if let doctorObject = dictionary["doctor"]  as? [String: AnyObject] {
            self.doctor = User(dictionary: doctorObject)
        }
        if let creatorObject = dictionary["patient"] as? [String: AnyObject] {
            self.creator = User(dictionary: creatorObject)
        }
        
        self.type = dictionary["type"] as? Int ?? 1
        self.rating = dictionary["rating"] as? Int ?? 1
        self.is_anonymous = dictionary["is_anonymous"] as? Bool ?? false
        
    }
    
}
