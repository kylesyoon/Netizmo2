//
//  SkillCell.swift
//  Netizmo
//
//  Created by Yoon, Kyle on 2/26/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import UIKit

class SkillCell: UICollectionViewCell {
    
    @IBOutlet var skillLabel: UILabel!
    static let cellIdentifier = "SkillCell"
    static let cellMargins = 8.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 5.0
    }
    
    func configureWithSkill(skill: String) {
        self.skillLabel.text = skill
        self.skillLabel.sizeToFit()
    }
    
    func configureSelectedState() {
        self.backgroundColor = UIColor.net_mainColor()
        self.skillLabel.textColor = UIColor.whiteColor()
    }
    
    func configureDeselectedState() {
        self.backgroundColor = UIColor.whiteColor()
        self.skillLabel.textColor = UIColor.blackColor()
    }
    
    static func cellSizeForSkill(skill: String) -> CGSize {
        let skillCell = NSBundle.mainBundle().loadNibNamed(self.cellIdentifier, owner: nil, options: nil).first as! SkillCell
        skillCell.configureWithSkill(skill)
        return skillCell.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
    }
    
}
