//
//  PhotoPickerCollectionViewCell.swift
//  PhotoPicker
//
//  Created by  lifirewolf on 16/3/4.
//  Copyright © 2016年  lifirewolf. All rights reserved.
//

import UIKit

class PhotoPickerCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "cell"
    
    var imgView: PhotoPickerImageView!
    
    var asset: PhotoAssets! {
        didSet {
            if let asset = asset {
                pickUp = asset.selected
                imgView.isVideoType = asset.isVideoType
                imgView.image = asset.thumbImage
            }
        }
    }
    
    var pickUp = false {
        didSet {
            asset?.selected = pickUp
            
            imgView?.maskViewFlag = pickUp
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        for v in contentView.subviews {
            v.removeFromSuperview()
        }
        
        imgView = PhotoPickerImageView(frame: bounds)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        
        imgView.contentMode = UIViewContentMode.ScaleAspectFit
        imgView.clipsToBounds = true
        contentView.addSubview(imgView)
        
        let views = ["imgView": imgView]
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[imgView]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[imgView]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
        
    }
    
    static func cellWithCollectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> PhotoPickerCollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! PhotoPickerCollectionViewCell
        
        return cell
    }
    
}

