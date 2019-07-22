//
//  FitnessCell.swift
//  iFitnessMan
//
//  Created by Apple on 2019/4/10.
//  Copyright © 2019年 whitelok.com. All rights reserved.
//

import UIKit

class FitnessCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var trackView: UIView!
    @IBOutlet weak var restView: UIView!
    @IBOutlet weak var playView: UIView!
    @IBOutlet weak var restLabel: UILabel!
    
    var imgArray = [String]()
    var time: Int = 0
    var restAnimation: CABasicAnimation!
    var playAnimation: CABasicAnimation!
//    var playAnimation: CABasicAnimation!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        self.stopImg()
        restView.layer.removeAnimation(forKey: "runRestPlay")
        playView.layer.removeAnimation(forKey: "runActionPlay")
        restLabel.isHidden = true
    }
    
    func setImg() {
        var imgs = [UIImage]()
        for i in 0...imgArray.count - 1 {
            if UIImage(named: imgArray[i]) != nil {
                imgs.append(UIImage(named: imgArray[i])!)
            }
        }
        imgView.animationImages = imgs
        imgView.animationDuration = 2
        imgView.image = imgs[0]
    }
    
    func playRest() {
        self.trackView.bounds.size.height = 10
        restAnimation = CABasicAnimation(keyPath: "bounds.size.width")
        restAnimation.toValue = self.trackView.frame.width
        restAnimation.duration = 20
        restAnimation.fillMode = .forwards
        restAnimation.isRemovedOnCompletion = true
        restView.layer.add(restAnimation, forKey: "runRestPlay")
        restLabel.isHidden = false
        restLabel.text = "休 息"
        restLabel.textColor = .lightGray
    }
    func playAction() {
        imgView.startAnimating()
        playAnimation = CABasicAnimation(keyPath: "bounds.size.width")
        playAnimation.toValue = self.trackView.frame.width
        playAnimation.duration = CFTimeInterval(time)
        playAnimation.fillMode = .forwards
        playAnimation.isRemovedOnCompletion = true
        playView.layer.add(playAnimation, forKey: "runActionPlay")
        restLabel.isHidden = false
        restLabel.text = "锻炼中"
        restLabel.textColor = UIColor(red: 129/255, green: 200/255, blue: 245/255, alpha: 1)
    }
    func stopImg() {
        imgView.stopAnimating()
        restLabel.isHidden = true
        self.trackView.bounds.size.height = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
