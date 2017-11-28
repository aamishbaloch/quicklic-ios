//
//  TestListTableViewCell.swift
//  Quicklic
//
//  Created by Danial Zahid on 27/11/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class TestListTableViewCell: UITableViewCell {
    
    static let identifier = "testListTableViewCell"

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
