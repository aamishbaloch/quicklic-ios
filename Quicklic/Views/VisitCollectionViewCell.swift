//
//  VisitCollectionViewCell.swift
//  Quicklic
//
//  Created by Furqan Nadeem on 12/7/17.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class VisitCollectionViewCell: UICollectionViewCell {

    static let identifier = "visitCollectionViewCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: DesignableImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
}
