//
//  NotificationL.swift
//  Quicklic
//
//  Created by Furqan Nadeem on 12/27/17.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import Foundation
class NotificationObject: BaseEntity {
    
    var id:String?
    var heading:String?
    var content:String?
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
        self.setValuesForKeysWithJSONDictionary(dictionary, dateFormatter: newDateFormatter)
        if let appointmentObject = dictionary["appointment"] as? [String: AnyObject] {
            self.appointment = Appointment(dictionary: appointmentObject)
        }
        self.is_read = dictionary["is_read"] as? Bool ?? false
//        if let creationDate = dictionary["created_at"] as? String {
//            UtilityManager.dateFromStringWithFormat(date: creationDate, format: "yyyy-MM-dd'T'hh:mm:ss.SSS")
//        }
    }
    
}
