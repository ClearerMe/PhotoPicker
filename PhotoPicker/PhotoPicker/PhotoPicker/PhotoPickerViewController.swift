//
//  PhotoPickerViewController.swift
//  PhotoPicker
//
//  Created by  lifirewolf on 16/3/4.
//  Copyright © 2016年  lifirewolf. All rights reserved.
//

import UIKit

enum PickerViewShowStatus: Int {
    case Group = 0 // default groups .
    case CameraRoll
    case SavePhotos
    case PhotoStream
    case Video
}

@objc protocol PhotoPickerViewControllerDelegate: NSObjectProtocol {
    /**
    *  返回所有的Asstes对象
    */
    func pickerViewControllerDoneAssets(assets: [PhotoAssets])
    
    /**
    *  点击拍照
    */
    optional func pickerCollectionViewSelectCamera(pickerVc: PhotoPickerViewController, withImage image: UIImage)
}

class PhotoPickerViewController: UIViewController {

    // @optional
    var delegate: PhotoPickerViewControllerDelegate! {
        didSet {
            groupVc.delegate = delegate
        }
    }
    
    // 决定你是否需要push到内容控制器, 默认显示组
    var status: PickerViewShowStatus! {
        didSet {
            groupVc.status = status
        }
    }
    
    // 可以用代理来返回值或者用block来返回值
    var callBack: ((obj: [AnyObject]) -> Void)?
    
    // 每次选择图片的最小数, 默认与最大数是9
    var maxCount = 0 {
        didSet {
            if maxCount > 0 {
                groupVc.maxCount = maxCount
            }
        }
    }
    
    // 记录选中的值
    var selectAsstes = [PhotoAssets]() {
        didSet {
            groupVc.selectAsstes = selectAsstes
        }
    }
    
    // 置顶展示图片
    var topShowPhotoPicker = false {
        didSet {
            groupVc.topShowPhotoPicker = topShowPhotoPicker
        }
    }
    
    var groupVc: PhotoPickerGroupViewController!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }

    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup() {
        let groupVc = PhotoPickerGroupViewController()
        let nav = UINavigationController(rootViewController: groupVc)
        nav.view.frame = view.bounds
        addChildViewController(nav)
        view.addSubview(nav.view)
        self.groupVc = groupVc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        addNotification()
    }
    
    // @function
    // 展示控制器
    func showPickerVc(vc: UIViewController) {
        vc.presentViewController(self, animated: true, completion: nil)
    }
    
    func addNotification() {
        // 监听异步done通知
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "done:", name: PICKER_TAKE_DONE, object: nil)
        }

        // 监听异步点击第一个Cell的拍照通知
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "selectCamera:", name: PICKER_TAKE_PHOTO, object: nil)
        }

    }
    
    func selectCamera(notification: NSNotification) {
        dispatch_async(dispatch_get_main_queue()) {
            if let delegate = self.delegate {
                if delegate.respondsToSelector("pickerCollectionViewSelectCamera") {
                    delegate.pickerCollectionViewSelectCamera!(self, withImage: notification.userInfo!["image"] as! UIImage)
                }
            }
        }
    }
    
    func done(notification: NSNotification) {
        let selectArray = notification.userInfo!["selectAssets"] as! [PhotoAssets]
        
        dispatch_async(dispatch_get_main_queue()) {
            
            if let delegate = self.delegate {
                if delegate.respondsToSelector("pickerViewControllerDoneAssets:") {
                    delegate.pickerViewControllerDoneAssets(selectArray)
                }
            } else if let callBack = self.callBack {
                callBack(obj: selectArray)
            }
            
            self.dismissViewControllerAnimated(true, completion: nil)

        }
    }
}
