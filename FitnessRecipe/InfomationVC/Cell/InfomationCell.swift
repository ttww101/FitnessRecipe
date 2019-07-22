//
//  InfomationCell.swift
//  FitnessRecipe
//
//  Created by Apple on 6/19/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class InfomationCell: UITableViewCell {
    
    @IBOutlet weak var infoImg: UIImageView!
    @IBOutlet weak var infoTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
