//
//  Time.swift
//  Quicklic
//
//  Created by Furqan Nadeem on 11/15/17.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class Time:BaseEntity {
    
    var start : NSDate?
    var end: NSDate?
    var available: Bool?
    
    override init() {
        super.init()
    }
    
    override init(dictionary: [AnyHashable : Any]!) {
        super.init()
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        newDateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        self.setValuesForKeysWithJSONDictionary(dictionary, dateFormatter: newDateFormatter)
        self.available = dictionary["available"] as? Bool
    }
    
    
}

