//
//  PhotoPickerFooterCollectionReusableView.swift
//  PhotoPicker
//
//  Created by  lifirewolf on 16/3/4.
//  Copyright © 2016年  lifirewolf. All rights reserved.
//

import UIKit

class PhotoPickerFooterCollectionReusableView: UICollectionReusableView {
    var count: Int! {
        didSet {
            if count > 0 {
                footerLabel.text = "有 \(count) 张图片"
            }
        }
    }
    
    var footerLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        footerLabel = UILabel()
        footerLabel.textAlignment = NSTextAlignment.Center
        footerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(footerLabel)
        
        addConstraint(NSLayoutConstraint(item: footerLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: footerLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
        
    }
    
}
