//
//  Test.swift
//  Quicklic
//
//  Created by Danial Zahid on 27/11/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class Test: BaseEntity {

    var id: String?
    var name: String?
    var price: String?
    var descriptionText: String?
    var sample_required: String?
    var result_expectation: String?
    var is_common: Bool?
    var is_featured: Bool?
    var is_active: Bool?
    var created_at: Date?
    
    override init() {
        super.init()
    }
    
    override init(dictionary: [AnyHashable : Any]!) {
        super.init()
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        self.setValuesForKeysWithJSONDictionary(dictionary, dateFormatter: newDateFormatter)
        
        self.descriptionText = dictionary["description"] as? String ?? ""
        self.is_featured = dictionary["is_featured"] as? Bool ?? false
        
        
    }
}
