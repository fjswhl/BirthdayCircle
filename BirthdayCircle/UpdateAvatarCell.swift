//
//  UpdateAvatarCell.swift
//  BirthdayCircle
//
//  Created by Lin on 15/2/14.
//  Copyright (c) 2015年 Lin. All rights reserved.
//

import UIKit

private let avatarImgHeight = 65.0
class UpdateAvatarCell: XLFormButtonCell {

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
        self.selectionStyle = UITableViewCellSelectionStyle.Default

        avatarImgView.image = UIImage(named: "user_avatar")
        
        self.addSubview(avatarImgView)
        
        
        layout(avatarImgView) { avatarImgView in
            avatarImgView.height == avatarImgHeight
            avatarImgView.height == avatarImgView.width
            avatarImgView.centerY == avatarImgView.superview!.centerY
            avatarImgView.trailing == avatarImgView.superview!.trailing - 16

        }
    }
    
    override func update() {
        super.update()
    }
    
    override class func formDescriptorCellHeightForRowDescriptor(rowDescriptor: XLFormRowDescriptor!) -> CGFloat {
        return 80.0
    }

}
