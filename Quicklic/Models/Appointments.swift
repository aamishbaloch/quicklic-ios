//
//  Appointments.swift
//  Quicklic
//
//  Created by Furqan Nadeem on 11/16/17.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class Appointments: BaseEntity {
    
    var id:Int?
    var name:String?
    var first_name:String?
    var last_name:String?
    
    override init() {
        super.init()
    }
    
    override init(dictionary: [AnyHashable : Any]!) {
        super.init()
        self.setValuesForKeysWithJSONDictionary(dictionary, dateFormatter: nil)
    }
}


