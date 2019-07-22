//
//  RecipeTableCell.swift
//  FitnessRecipe
//
//  Created by Apple on 5/24/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class RecipeTableCell: UITableViewCell {
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var collectionBtn: UIButton!
    @IBOutlet weak var eatBtn: UIButton!
    
    var heartClosure: (() -> Void)?
    var eatClosure: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func heartClick(_ sender: UIButton) {
        heartClosure?()
    }
    @IBAction func eatClick(_ sender: UIButton) {
        eatClosure?()
    }
}
