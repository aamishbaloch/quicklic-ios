//
//  ProfileTableViewCell.swift
//  Quicklic
//
//  Created by Danial Zahid on 18/10/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    static let identifier = "profileTableViewCell"

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var bodyField: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
