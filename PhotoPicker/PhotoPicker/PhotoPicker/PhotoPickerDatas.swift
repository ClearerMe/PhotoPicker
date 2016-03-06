//
//  PhotoPickerDatas.swift
//  PhotoPicker
//
//  Created by  lifirewolf on 16/3/4.
//  Copyright © 2016年  lifirewolf. All rights reserved.
//

import UIKit
import AssetsLibrary

class PhotoPickerDatas: NSObject {
    
    static func defaultAssetsLibrary() -> ALAssetsLibrary {
        
        struct Static {
            static var pred: dispatch_once_t = 0
            static var library: ALAssetsLibrary!
        }
        
        dispatch_once(&Static.pred) {
            Static.library = ALAssetsLibrary()
        }
        
        return Static.library
    }
    
    private var realLibrary: ALAssetsLibrary!
    var library: ALAssetsLibrary {
        if realLibrary == nil {
            realLibrary = PhotoPickerDatas.defaultAssetsLibrary()
        }
        return realLibrary
    }
    
    /**
    *  获取所有组
    */
    static func defaultPicker() -> PhotoPickerDatas {
        return PhotoPickerDatas()
    }
    
    /**
    * 获取所有组对应的图片
    */
    func getAllGroupWithPhotos(callBack: ((inout obj: [PhotoPickerGroup]) -> Void)) {
        getAllGroupAllPhotos(true, resource: callBack)
    }
    
    func getAllGroupAllPhotos(allPhotos: Bool, resource callBack: (inout obj: [PhotoPickerGroup]) -> Void) {
        
        var groups = [PhotoPickerGroup]()
        
        let resultBlock: ALAssetsLibraryGroupsEnumerationResultsBlock = { group, stop in
            
            if group != nil {
                if allPhotos {
                    group.setAssetsFilter(ALAssetsFilter.allPhotos())
                } else {
                    group.setAssetsFilter(ALAssetsFilter.allVideos())
                }
                // 包装一个模型来赋值
                let pickerGroup = PhotoPickerGroup()
                pickerGroup.group = group
                pickerGroup.groupName = group.valueForProperty("ALAssetsGroupPropertyName") as! String
                pickerGroup.thumbImage = UIImage(CGImage: group.posterImage().takeUnretainedValue())
                pickerGroup.assetsCount = group.numberOfAssets()
                groups.append(pickerGroup)

            } else {
                callBack(obj: &groups)
            }
        }
        
        library.enumerateGroupsWithTypes(ALAssetsGroupAll, usingBlock: resultBlock, failureBlock: nil)
    }

    /**
    * 获取所有组对应的Videos
    */
    func getAllGroupWithVideos(callBack: (inout obj: [PhotoPickerGroup]) -> Void) {
        getAllGroupAllPhotos(true, resource: callBack)
    }
    
    /**
    *  传入一个组获取组里面的Asset
    */
    func getGroupPhotosWithGroup(pickerGroup: PhotoPickerGroup, finished callBack: ((inout obj: [ALAsset]) -> Void)?) {
        
        var assets = [ALAsset]()
        
        let result: ALAssetsGroupEnumerationResultsBlock = {asset, index, stop in
            
            if asset != nil {
                assets.append(asset)
            } else {
                callBack?(obj: &assets)
            }
        }
        
        pickerGroup.group.enumerateAssetsUsingBlock(result)
    }
    
    /**
    *  传入一个AssetsURL来获取UIImage
    */
    func getAssetsPhotoWithURLs(url: NSURL, callBack:((obj: UIImage) -> Void)?) {
        
        library.assetForURL(url,
            resultBlock: { asset in
                if asset != nil {
                    let assetRep: ALAssetRepresentation = asset.defaultRepresentation()
                    let iref = assetRep.fullResolutionImage().takeUnretainedValue()
                    callBack?(obj: UIImage(CGImage: iref))
                }
            }, failureBlock: { error in
                
            }
        )
    }
    
}
