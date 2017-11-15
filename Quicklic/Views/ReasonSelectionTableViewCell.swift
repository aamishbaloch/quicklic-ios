//
//  ReasonSelectionTableViewCell.swift
//  Quicklic
//
//  Created by Furqan Nadeem on 11/14/17.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class ReasonSelectionTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblReason: UILabel!
    static let identifier = "reasonSelectionTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
