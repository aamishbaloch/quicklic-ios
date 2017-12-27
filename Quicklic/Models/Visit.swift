//
//  Visit.swift
//  Quicklic
//
//  Created by Furqan Nadeem on 12/8/17.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import Foundation
class Visit: BaseEntity {
    
    
    var comments:String?
    
    override init() {
        super.init()
    }
    
    override init(dictionary: [AnyHashable : Any]!) {
        super.init()
        
        self.setValuesForKeysWithJSONDictionary(dictionary, dateFormatter: nil)
    }
    
}
