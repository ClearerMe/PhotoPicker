//
//  PhotoPickerCommon.swift
//  PhotoPicker
//
//  Created by  lifirewolf on 16/3/4.
//  Copyright © 2016年  lifirewolf. All rights reserved.
//

import UIKit

// 点击销毁的block
typealias pickerBrowserViewControllerTapDisMissBlock = (Int) -> Void

// 点击View执行的动画
enum UIViewAnimationAnimationStatus: Int {
    case Zoom = 0 // 放大缩小
    case Fade // 淡入淡出
}

// 图片最多显示9张，超过9张取消单击事件
let photoShowMaxCount = 9

// ScrollView 滑动的间距
let pickerColletionViewPadding = CGFloat(10)

// ScrollView拉伸的比例
let pickerScrollViewMaxZoomScale = CGFloat(3.0)
let pickerScrollViewMinZoomScale = CGFloat(1.0)

// 进度条的宽度/高度
let pickerProgressViewW = 50
let pickerProgressViewH = 50

// 分页控制器的高度
let pickerPageCtrlH = 25

// NSNotification
let PICKER_TAKE_DONE = "PICKER_TAKE_DONE"
let PICKER_TAKE_PHOTO = "PICKER_TAKE_PHOTO"

let PICKER_PowerBrowserPhotoLibirayText = "您屏蔽了选择相册的权限，开启请去系统设置->隐私->我的App来打开权限"

