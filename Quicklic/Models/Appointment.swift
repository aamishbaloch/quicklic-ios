//
//  Appointments.swift
//  Quicklic
//
//  Created by Furqan Nadeem on 11/16/17.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

enum AppointmentStatus: Int {
    case Confirm = 1, Pending, NoShow, Cancel, Discard = 5
    
        var value : String {
        switch self {
        case .Confirm:
            return "Confirmed"
        case .Pending:
            return "Pending"
        case .NoShow:
            return "No Show"
        case .Cancel:
            return "Cancel"
        case .Discard:
            return "Discard"
        }
    }
}

class Appointment: BaseEntity {
    
    /*
     {
     clinic =     {
     id = 1;
     image = "http://staging.quicklic.com/media/uploads/clinics/cvs-minute-clinic-walk-in-clinic-review_J61uC7B.jpg";
     name = "Baloch Clinic";
     };
     "created_at" = "2017-11-16T12:21:28.542223";
     doctor =     {
     avatar = "<null>";
     "first_name" = Dr;
     id = 2;
     "last_name" = "Jim Jones";
     phone = "+923214170655";
     specialization =         {
     id = 2;
     name = Radiology;
     };
     };
     "end_datetime" = "2017-11-15T12:50:00";
     id = 24;
     "is_active" = 1;
     notes = "<null>";
     patient =     {
     avatar = "<null>";
     "first_name" = Danial;
     id = 10;
     "last_name" = Zahid;
     phone = "+13349821389";
     };
     qid = "10-2-1900";
     reason =     {
     id = 2;
     name = "Followup Appointment";
     };
     "start_datetime" = "2017-11-15T12:00:00";
     status = 2;
     }
     */
    
    var id:String?
    var name:String?
   //var first_name:String?
   //var last_name:String?
    var clinic = Clinic()
    var doctor = User()
    var patient = User()
    var reason = GenericModel()
    var start_datetime:Date?
    var end_datetime:Date?
    var status: AppointmentStatus?
    
    
    override init() {
        super.init()
    }
    
    override init(dictionary: [AnyHashable : Any]!) {
        super.init()
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//      newDateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        self.setValuesForKeysWithJSONDictionary(dictionary, dateFormatter: newDateFormatter)
        self.clinic = Clinic(dictionary: dictionary["clinic"] as! [String: AnyObject])
        self.doctor = User(dictionary: dictionary["doctor"]  as! [String: AnyObject])
        self.reason = GenericModel(dictionary: dictionary["reason"] as! [String: AnyObject])
        self.patient = User(dictionary: dictionary["patient"] as! [String: AnyObject])
        self.status = AppointmentStatus(rawValue: dictionary["status"] as? Int ?? 2)
    }
}


