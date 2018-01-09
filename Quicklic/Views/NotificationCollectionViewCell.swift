//
//  NotificationCollectionViewCell.swift
//  Quicklic
//
//  Created by Furqan Nadeem on 12/27/17.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class NotificationCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "NotificationCollectionViewCell"
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var imageView: DesignableImageView!
    
    @IBOutlet weak var contentLabel: UILabel!
    
}
