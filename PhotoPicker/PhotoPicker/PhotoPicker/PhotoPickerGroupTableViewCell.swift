//
//  PhotoPickerGroupTableViewCell.swift
//  PhotoPicker
//
//  Created by  lifirewolf on 16/3/4.
//  Copyright © 2016年  lifirewolf. All rights reserved.
//

import UIKit

class PhotoPickerGroupTableViewCell: UITableViewCell {
    
    var group: PhotoPickerGroup! {
        didSet {
            groupNameLabel.text = group.groupName
            groupImageView.image = group.thumbImage
            groupPicCountLabel.text = "\(group.assetsCount)"
        }
    }
    
    var groupImageView: UIImageView!
    var groupNameLabel: UILabel!
    var groupPicCountLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {

        groupImageView = UIImageView()
        groupImageView.frame = CGRect(x: 15, y: 5, width: 70, height: 70)
        groupImageView.contentMode = UIViewContentMode.ScaleAspectFit
        contentView.addSubview(groupImageView)
        
        groupNameLabel = UILabel()
        groupNameLabel.frame = CGRect(x: 95, y: 15, width: frame.width - 100, height: 20)
        contentView.addSubview(groupNameLabel)
        
        groupPicCountLabel = UILabel()
        groupPicCountLabel.font = UIFont.systemFontOfSize(13)
        groupPicCountLabel.textColor = UIColor.lightGrayColor()
        groupPicCountLabel.frame = CGRect(x: 95, y: 40, width: frame.width - 100, height: 20)
        contentView.addSubview(groupPicCountLabel)
    }
}
