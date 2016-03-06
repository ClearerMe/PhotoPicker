//
//  PhotoPickerImageView.swift
//  PhotoPicker
//
//  Created by  lifirewolf on 16/3/4.
//  Copyright © 2016年  lifirewolf. All rights reserved.
//

import UIKit

class PhotoPickerImageView: UIImageView {
    
    /**
    *  是否有蒙版层
    */
    var maskViewFlag = false {
        didSet {
            if !maskViewFlag {
                tickImageView.image = SourceUtil.imageFromBundleName(ImageName.unSelected)
            } else {
                tickImageView.image = SourceUtil.imageFromBundleName(ImageName.selected)
            }
            
            animationRightTick = maskViewFlag
        }
    }
    
    /**
    *  蒙版层的颜色,默认白色
    */
    var maskViewColor: UIColor! {
        didSet {
            aMaskView.backgroundColor = maskViewColor
        }
    }
    
    /**
    *  蒙版的透明度,默认 0.5
    */
    var maskViewAlpha: CGFloat! {
        didSet {
            aMaskView.alpha = maskViewAlpha
        }
    }
    
    /**
    *  是否有右上角打钩的按钮
    */
    var animationRightTick = false
    
    /**
    *  是否视频类型
    */
    var isVideoType = true {
        didSet {
            videoView.hidden = !isVideoType
        }
    }
    
    var aMaskView: UIView!
    var tickImageView: UIImageView!
    var videoView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        contentMode = UIViewContentMode.ScaleAspectFill
        clipsToBounds = true
        
        aMaskView = UIView()
        aMaskView.frame = self.bounds
        aMaskView.backgroundColor = UIColor.whiteColor()
        aMaskView.alpha = 0.0
        addSubview(aMaskView)
        
        videoView = UIImageView(frame: CGRect(x: 10, y: bounds.height - 40, width: 30, height: 30))
        videoView.image = SourceUtil.imageFromBundleName(ImageName.video)
        videoView.contentMode = UIViewContentMode.ScaleAspectFit
        addSubview(videoView)
        
        tickImageView = UIImageView(frame: CGRect(x: bounds.width - 28, y: 5, width: 21, height: 21))
        tickImageView.frame = CGRectMake(self.bounds.size.width - 28, 5, 21, 21)
        tickImageView.image = SourceUtil.imageFromBundleName(ImageName.unSelected)
        //        tickImageView.hidden = true
        addSubview(tickImageView)

    }
    
}
