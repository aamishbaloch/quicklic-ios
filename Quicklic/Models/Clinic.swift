//
//  Clinic.swift
//  Quicklic
//
//  Created by Danial Zahid on 27/10/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class Clinic: BaseEntity {
    
    var id: String?
    var name: String?
    var phone: String?
    var location: String?
    var image_thumb: String?
    var rating:String?
    var email: String?
    var website: String?
    var is_lab: Bool?
    var formatted_address: String?

    override init() {
        super.init()
    }
    
    override init(dictionary: [AnyHashable : Any]!) {
        super.init()
        self.setValuesForKeysWithJSONDictionary(dictionary, dateFormatter: nil)
        self.location = dictionary["formatted_address"] as? String ?? ""
    }
}
