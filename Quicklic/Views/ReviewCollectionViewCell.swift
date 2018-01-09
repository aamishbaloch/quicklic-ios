//
//  ReviewCollectionViewCell.swift
//  Quicklic
//
//  Created by Furqan Nadeem on 11/28/17.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class ReviewCollectionViewCell: UICollectionViewCell {
    static let identifier = "reviewCollectionViewCell"
  
    @IBOutlet weak var imageView: DesignableImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        widthConstraint.constant = screenWidth - 15
    }
    
}
