//
//  ClinicCollectionViewCell.swift
//  Quicklic
//
//  Created by Danial Zahid on 27/10/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class ClinicCollectionViewCell: UICollectionViewCell {
    static let identifier = "clinicCollectionViewCell"
    
    @IBOutlet weak var clinicImageView: DesignableImageView!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var ratingView: HCSStarRatingView!
}
