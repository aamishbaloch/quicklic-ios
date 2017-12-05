//
//  PatientCollectionViewCell.swift
//  Quicklic
//
//  Created by Danial Zahid on 18/09/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class PatientCollectionViewCell: UICollectionViewCell {
    static let identifier = "patientCollectionViewCell"
    
    @IBOutlet weak var imageView: DesignableImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
}
