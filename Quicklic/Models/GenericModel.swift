//
//  GenericModel.swift
//  Quicklic
//
//  Created by Danial Zahid on 16/10/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class GenericModel: BaseEntity {

    var id: String?
    var name: String?
    
    override init() {
        super.init()
    }
    
    override init(dictionary: [AnyHashable : Any]!) {
        super.init()
        self.setValuesForKeysWithJSONDictionary(dictionary, dateFormatter: nil)
    }
    
}
