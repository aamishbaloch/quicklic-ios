//
//  SearchDoctorCollectionViewCell.swift
//  Quicklic
//
//  Created by Danial Zahid on 30/08/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class SearchDoctorCollectionViewCell: UICollectionViewCell {
    static let identifier = "searchDoctorCollectionViewCell"
    
    
    @IBOutlet weak var profileImageView: DesignableImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var specializationLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    
}
