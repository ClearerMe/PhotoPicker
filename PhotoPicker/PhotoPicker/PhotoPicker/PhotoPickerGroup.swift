//
//  PhotoPickerGroup.swift
//  PhotoPicker
//
//  Created by  lifirewolf on 16/3/4.
//  Copyright © 2016年  lifirewolf. All rights reserved.
//

import UIKit
import AssetsLibrary

class PhotoPickerGroup : NSObject {
    
    /**
    *  组名
    */
    var groupName: String!
    
    /**
    *  缩略图
    */
    var thumbImage: UIImage!
    
    /**
    *  组里面的图片个数
    */
    var assetsCount: NSInteger!
    
    /**
    *  类型 : Saved Photos...
    */
    var type: String!
    
    var group: ALAssetsGroup!
}
