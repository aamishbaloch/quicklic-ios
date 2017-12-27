//
//  NotificationL.swift
//  Quicklic
//
//  Created by Furqan Nadeem on 12/27/17.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import Foundation
class NotificationL: BaseEntity {
    
    var id:String?
    var heading:String?
    var content:String?
    var clinic = Clinic()
    var doctor = User()
    var patient = User()
    var type : Int?
    var user_type : Int?
    var moderator: Int?
    var created_at:Date?
    var is_read: Bool?
    var appointment:Appointment?
    
    override init() {
        super.init()
    }
    
    override init(dictionary: [AnyHashable : Any]!) {
        super.init()
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = Constant.serverDateFormatExtended
        //        newDateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        self.setValuesForKeysWithJSONDictionary(dictionary, dateFormatter: newDateFormatter)
        //        if let clinicObject = dictionary["clinic"] as? [String: AnyObject] {
        //            self.clinic = Clinic(dictionary: clinicObject)
        //        }
        //        if let doctorObject = dictionary["doctor"]  as? [String: AnyObject] {
        //            self.doctor = User(dictionary: doctorObject)
        //        }
        //        if let patientObject = dictionary["patient"] as? [String: AnyObject] {
        //            self.creator = User(dictionary: creatorObject)
        //        }
        
}
    
}
