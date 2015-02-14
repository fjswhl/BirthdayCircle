//
//  MeCell.swift
//  BirthdayCircle
//
//  Created by Lin on 15/2/13.
//  Copyright (c) 2015年 Lin. All rights reserved.
//

import UIKit

private let avatarImgHeight = 65.0

class MeCell: XLFormBaseCell {
    let nameLabel = UILabel()
    let birthdayLabel = UILabel()
    let avatarImgView = UIImageView()
    
    // MARK: -
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        super.configure()
        self.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        self.selectionStyle = .None

        nameLabel.font = UIFont.systemFontOfSize(16.0)
        birthdayLabel.font = UIFont.systemFontOfSize(13.0)
        birthdayLabel.textColor = HexUIColor("FF351F")

        avatarImgView.image = UIImage(named: "user_avatar")
        
        
        self.addSubview(nameLabel)
        self.addSubview(birthdayLabel)
        self.addSubview(avatarImgView)

        
        layout(nameLabel, birthdayLabel, avatarImgView) { nameLabel, birthdayLabel, avatarImgView in
            avatarImgView.height == avatarImgHeight
            avatarImgView.height == avatarImgView.width
            avatarImgView.centerY == avatarImgView.superview!.centerY
            avatarImgView.leading == avatarImgView.superview!.leading + 16
            
            nameLabel.leading == avatarImgView.trailing + 12
            nameLabel.centerY == nameLabel.superview!.centerY - 13
            birthdayLabel.leading == nameLabel.leading
            birthdayLabel.top == nameLabel.bottom + 4
        }
    }
    
    override func update() {
        super.update()
    }
}
