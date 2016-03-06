//
//  PhotoPickerCollectionView.swift
//  PhotoPicker
//
//  Created by  lifirewolf on 16/3/4.
//  Copyright © 2016年  lifirewolf. All rights reserved.
//

import UIKit
import AssetsLibrary

enum PickerCollectionViewShowOrderStatus: Int {
    case TimeDesc = 0 // 升序
    case TimeAsc // 降序
}

protocol PhotoPickerCollectionViewDelegate: NSObjectProtocol {
    // 选择相片就会调用
    func pickerCollectionViewDidSelected(pickerCollectionView: PhotoPickerCollectionView, deleteAsset deleteAssets: PhotoAssets?)
    
    // 点击拍照就会调用
    func pickerCollectionViewDidCameraSelect(pickerCollectionView: PhotoPickerCollectionView)
}

class PhotoPickerCollectionView: UICollectionView {
    // scrollView滚动的升序降序
    var status: PickerCollectionViewShowOrderStatus!
    
    // 保存所有的数据
    var dataArray = [PhotoAssets]() {
        didSet {
            reloadData()
        }
    }
    
    var selectAssets = [PhotoAssets]()

    // delegate
    var collectionViewDelegate: PhotoPickerCollectionViewDelegate?
    
    // 限制最大数
    var maxCount = 0
    
    var footerView: PhotoPickerFooterCollectionReusableView!
    
    // 判断是否是第一次加载
    var firstLoadding = false
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup() {
        backgroundColor = UIColor.clearColor()
        dataSource = self
        delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 时间置顶的话
        if status == .TimeDesc {
            
            if !firstLoadding && contentSize.height > UIScreen.mainScreen().bounds.height {
                // 滚动到最底部（最新的）
                let ip = NSIndexPath(forItem: dataArray.count - 1, inSection: 0)
                scrollToItemAtIndexPath(ip, atScrollPosition: .Bottom, animated: false)
                contentOffset = CGPointMake(contentOffset.x, contentOffset.y + 100)
                firstLoadding = true
            }
            
        } else if status == .TimeAsc {
            
            // 滚动到最底部（最新的）
            if !firstLoadding && contentSize.height > UIScreen.mainScreen().bounds.height {
                // 滚动到最底部（最新的）
                let ip = NSIndexPath(forItem: 0, inSection: 0)
                scrollToItemAtIndexPath(ip, atScrollPosition: .Top, animated: false)
                // 展示图片数
                contentOffset = CGPointMake(contentOffset.x, contentInset.top)
                firstLoadding = true
            }
        }
    }
    
}

extension PhotoPickerCollectionView: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = PhotoPickerCollectionViewCell.cellWithCollectionView(collectionView, cellForItemAtIndexPath: indexPath)
        
        let asset = dataArray[indexPath.row]
        
        cell.asset = asset
        cell.imgView.tag = indexPath.item
        
        return cell
    }
}

extension PhotoPickerCollectionView: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PhotoPickerCollectionViewCell
        
        let asset = dataArray[indexPath.row]
        
        let isSelected = !asset.selected
        
        if isSelected {
            // 1 判断图片数超过最大数或者小于0
            let maxCount = self.maxCount < 0 ? photoShowMaxCount : self.maxCount
            
            if selectAssets.count >= maxCount {
                var format: String
                if maxCount == 0 {
                    format = "您已经选满了图片呦."
                } else {
                    format = "最多只能选择\(maxCount)张图片"
                }
                
                let alert = UIAlertView(title: "提醒", message: format, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "好的")
                alert.show()

                return
            }
            
            selectAssets.append(cell.asset)
            
        } else {
            for i in 0..<selectAssets.count {
                if cell.asset.asset.defaultRepresentation().url().absoluteString == selectAssets[i].asset.defaultRepresentation().url().absoluteString {
                    selectAssets.removeAtIndex(i)
                    break
                }
            }
        }
        
        cell.pickUp = isSelected
        
        // 告诉代理现在被点击了!
        if collectionViewDelegate != nil && collectionViewDelegate!.respondsToSelector("pickerCollectionViewDidSelected:deleteAsset:") {
            
            if !isSelected {
                // 删除的情况下
                collectionViewDelegate!.pickerCollectionViewDidSelected(self, deleteAsset: cell.asset)
            } else {
                collectionViewDelegate!.pickerCollectionViewDidSelected(self, deleteAsset: nil)
            }
        }

    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionFooter {
            
            let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "FooterView", forIndexPath: indexPath) as! PhotoPickerFooterCollectionReusableView
            footerView.count = dataArray.count
            self.footerView = footerView
            
            return footerView
        } else {
            return UICollectionReusableView()
        }
        
    }
    
}

extension PhotoPickerCollectionView: UIAlertViewDelegate {
    
}
