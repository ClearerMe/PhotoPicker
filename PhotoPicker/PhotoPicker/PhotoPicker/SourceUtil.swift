//
//  UIIMage+Extension.swift
//  PhotoPicker
//
//  Created by  lifirewolf on 16/3/4.
//  Copyright © 2016年  lifirewolf. All rights reserved.
//

import UIKit

class SourceUtil {
    static func imageFromBundleName(name: ImageName) -> UIImage {
        return UIImage(named: "ImageLib.bundle/\(name.rawValue)")!
    }
}

enum ImageName: String {
    case lock = "lock"
    case video = "video"
    case unSelected = "icon_image_no"
    case selected = "icon_image_yes"
}