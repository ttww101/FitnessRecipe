//
//  LessonCell.swift
//  FitnessRecipe
//
//  Created by Apple on 6/10/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class LessonCell: UITableViewCell {
    @IBOutlet weak var lessonImg: UIImageView!
    @IBOutlet weak var lessonTitle: UILabel!
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var sortLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        self.sortView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
