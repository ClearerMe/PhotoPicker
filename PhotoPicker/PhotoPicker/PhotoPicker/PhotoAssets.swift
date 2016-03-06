//
//  PhotoAssets.swift
//  PhotoPicker
//
//  Created by  lifirewolf on 16/3/4.
//  Copyright © 2016年  lifirewolf. All rights reserved.
//

import UIKit
import AssetsLibrary

class PhotoAssets: NSObject {
    
    /**
    *  获取是否是视频类型
    */
    var isVideoType = false
    
    var asset: ALAsset!
    
    var image: UIImage {
        return UIImage(CGImage: asset.thumbnail().takeUnretainedValue())
    }
    
    /**
    *  缩略图
    */
    var aspectRatioImage: UIImage {
        return UIImage(CGImage: asset.aspectRatioThumbnail().takeUnretainedValue())
    }
    
    /**
    *  缩略图
    */
    var thumbImage: UIImage {
        return UIImage(CGImage: asset.thumbnail().takeUnretainedValue())
    }
    
    /**
    *  原图
    */
    var originImage: UIImage {
        return UIImage(CGImage: asset.defaultRepresentation().fullScreenImage().takeUnretainedValue())
    }
    
    /**
    *  获取图片的URL
    */
    var assetURL: NSURL {
        return asset.defaultRepresentation().url()
    }
    
    var selected = false
    
}