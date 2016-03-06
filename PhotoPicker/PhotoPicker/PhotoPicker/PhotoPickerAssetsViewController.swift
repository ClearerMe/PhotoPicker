//
//  PhotoPickerAssetsViewController.swift
//  PhotoPicker
//
//  Created by  lifirewolf on 16/3/4.
//  Copyright © 2016年  lifirewolf. All rights reserved.
//

import UIKit
import AssetsLibrary

let CELL_ROW: CGFloat = 4
let CELL_MARGIN: CGFloat = 2
let CELL_LINE_MARGIN: CGFloat = 2
let TOOLBAR_HEIGHT: CGFloat = 44

let _cellIdentifier = "cell"
let _footerIdentifier = "FooterView"
let _identifier = "toolBarThumbCollectionViewCell"

class PhotoPickerAssetsViewController: UIViewController {

    var groupVc: PhotoPickerGroupViewController!
    var status: PickerViewShowStatus!
    
    var assetsGroup: PhotoPickerGroup! {
        didSet {
            if assetsGroup.groupName.characters.count == 0 {
                return
            }
            
            self.title = assetsGroup.groupName
            
            // 获取Assets
            PhotoPickerDatas.defaultPicker().getGroupPhotosWithGroup(self.assetsGroup) { assets in
                var assetsM = [PhotoAssets]()
                for asset in assets {
                    let zlAsset = PhotoAssets()
                    zlAsset.asset = asset
                    
                    for selected in self.selectPickerAssets {
                        if asset.defaultRepresentation().url().absoluteString == selected.asset.defaultRepresentation().url().absoluteString {
                            zlAsset.selected = true
                            
                            self.selectAssets.append(zlAsset)
                            
                            break
                        }
                    }
                    assetsM.append(zlAsset)
                }

                self.collectionView.dataArray = assetsM
            }
        }
    }
    
    var maxCount: Int! {
        didSet {
            if 0 == privateTempMaxCount {
                privateTempMaxCount = maxCount
            }
            
            self.collectionView.maxCount = maxCount
        }
    }
    
    // 需要记录选中的值的数据
    var selectPickerAssets = [PhotoAssets]()
    
    var collectionView: PhotoPickerCollectionView!
    // 底部CollectionView
    var toolBarThumbCollectionView: UICollectionView!
    // 标记View
    var makeView: UILabel!
    var doneBtn: UIButton!
    var toolBar: UIToolbar!
    
    var privateTempMaxCount = 0

    // 记录选中的assets
    var selectAssets = [PhotoAssets]() {
        didSet{
            self.collectionView.selectAssets = self.selectAssets
            let count = self.selectAssets.count
            self.makeView.hidden = count == 0
            self.makeView.text = "\(count)"
            self.doneBtn.enabled = count > 0
        }
    }
    
    // 拍照后的图片数组
    var takePhotoImages = [PhotoAssets]()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.bounds = UIScreen.mainScreen().bounds
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    func setupUI() {
        
        makeView = UILabel()
        makeView.textColor = UIColor.whiteColor()
        makeView.textAlignment = NSTextAlignment.Center
        makeView.font = UIFont.systemFontOfSize(13)
        makeView.frame = CGRectMake(-5, -5, 20, 20)
        makeView.hidden = true
        makeView.layer.cornerRadius = makeView.frame.size.height / 2.0;
        makeView.clipsToBounds = true
        makeView.backgroundColor = UIColor.redColor()
        self.view.addSubview(makeView)
        
        let rightBtn = UIButton(type: UIButtonType.Custom)
        rightBtn.setTitleColor(UIColor(red: 0, green: 91 / 255.0, blue: 1, alpha: 1), forState: UIControlState.Normal)
        rightBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Disabled)
        
        rightBtn.enabled = true
        rightBtn.titleLabel?.font = UIFont.systemFontOfSize(17)
        rightBtn.frame = CGRectMake(0, 0, 45, 45)
        rightBtn.setTitle("完成", forState: UIControlState.Normal)
        rightBtn.addTarget(self, action: "done", forControlEvents: UIControlEvents.TouchUpInside)
        rightBtn.addSubview(self.makeView)
        self.doneBtn = rightBtn
        
        toolBar = UIToolbar()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolBar)
        
        var views: [String: AnyObject] = ["toolBar": toolBar]
        var widthVfl = "H:|-0-[toolBar]-0-|"
        var heightVfl = "V:[toolBar(44)]-0-|"
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(widthVfl, options: NSLayoutFormatOptions(), metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(heightVfl, options: NSLayoutFormatOptions(), metrics: nil, views: views))
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSizeMake(40, 40)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 5
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        // CGRectMake(0, 22, 300, 44)
        toolBarThumbCollectionView = UICollectionView(frame: CGRectMake(10, 0, view.frame.width - 100, 44), collectionViewLayout: flowLayout)
        toolBarThumbCollectionView.backgroundColor = UIColor.clearColor()
        toolBarThumbCollectionView.dataSource = self
//        toolBarThumbCollectionView.delegate = self
        toolBarThumbCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: _identifier)
        
        toolBar.addSubview(toolBarThumbCollectionView)
        
        // 左视图 中间距 右视图
        let leftItem = UIBarButtonItem(customView: self.toolBarThumbCollectionView)
        
        let fiexItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        
        let rightItem = UIBarButtonItem(customView: self.doneBtn)
        
        toolBar.items = [leftItem, fiexItem, rightItem]

        
        let cellW = (self.view.frame.size.width - CELL_MARGIN * CELL_ROW + 1) / CELL_ROW
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(cellW, cellW)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = CELL_LINE_MARGIN
        layout.footerReferenceSize = CGSizeMake(self.view.frame.size.width, TOOLBAR_HEIGHT * 2)
        
        collectionView = PhotoPickerCollectionView(frame: CGRectZero, collectionViewLayout: layout)
        
        // 时间置顶
        collectionView.status = PickerCollectionViewShowOrderStatus.TimeDesc
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.registerClass(PhotoPickerCollectionViewCell.self, forCellWithReuseIdentifier: _cellIdentifier)
        
        // 底部的View
        collectionView.registerClass(PhotoPickerFooterCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: _footerIdentifier)
        
        collectionView.contentInset = UIEdgeInsetsMake(5, 0,TOOLBAR_HEIGHT, 0)
        collectionView.collectionViewDelegate = self
        view.insertSubview(collectionView, belowSubview: toolBar)
        
        views = ["collectionView": collectionView]
        
        widthVfl = "H:|-0-[collectionView]-0-|"
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(widthVfl, options: NSLayoutFormatOptions(), metrics: nil, views: views))
        
        heightVfl = "V:|-0-[collectionView]-0-|"
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(heightVfl, options: NSLayoutFormatOptions(), metrics: nil, views: views))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Done, target: self, action: "back")
    }
    
    func back() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func done() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            NSNotificationCenter.defaultCenter().postNotificationName(PICKER_TAKE_DONE, object: nil, userInfo: ["selectAssets": self.selectAssets])
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        groupVc.selectAsstes = self.selectAssets
    }
}

extension PhotoPickerAssetsViewController: PhotoPickerCollectionViewDelegate {
    // 选择相片就会调用
    func pickerCollectionViewDidSelected(pickerCollectionView: PhotoPickerCollectionView, deleteAsset deleteAssets: PhotoAssets?) {

        self.selectAssets = pickerCollectionView.selectAssets
        
        let count = self.selectAssets.count
        self.makeView.hidden = count == 0
        self.makeView.text = "\(count)"
        self.doneBtn.enabled = count > 0
        
        self.toolBarThumbCollectionView.reloadData()
    }
    
    // 点击拍照就会调用
    func pickerCollectionViewDidCameraSelect(pickerCollectionView: PhotoPickerCollectionView) {
        let ctrl = UIImagePickerController()
        ctrl.delegate = self
        ctrl.sourceType = UIImagePickerControllerSourceType.Camera
        takePhotoImages = []
        presentViewController(ctrl, animated: true, completion: nil)
    }
}

extension PhotoPickerAssetsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            // 处理
            let asset = info["UIImagePickerControllerOriginalImage"] as! ALAsset
            let image = PhotoAssets()
            image.asset = asset
            
            self.selectAssets.append(image)
            self.toolBarThumbCollectionView.reloadData()
            self.takePhotoImages.append(image)
            
            dispatch_async(dispatch_get_global_queue(0, 0)) {
                NSNotificationCenter.defaultCenter().postNotificationName(PICKER_TAKE_PHOTO, object: nil, userInfo: ["image": image])
            }
            
            let count = self.selectAssets.count
            self.makeView.hidden = count == 0
            self.makeView.text = "\(count)"
            self.doneBtn.enabled = count > 0
            picker.dismissViewControllerAnimated(true, completion: nil)
        } else {
            NSLog("请在真机使用!")
        }
    }
}

extension PhotoPickerAssetsViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectAssets.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(_identifier, forIndexPath: indexPath)
        
        if self.selectAssets.count > indexPath.item {
            var imageView = cell.contentView.subviews.last as? UIImageView
            
            if imageView == nil {
                
                for v in cell.contentView.subviews {
                    v.removeFromSuperview()
                }
                
                imageView = UIImageView(frame: cell.frame)
                imageView!.translatesAutoresizingMaskIntoConstraints = false
                
                imageView!.contentMode = UIViewContentMode.ScaleAspectFit
                imageView!.clipsToBounds = true
                cell.contentView.addSubview(imageView!)
                
                let views = ["imageView": imageView!]
                cell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[imageView]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
                cell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[imageView]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
            }

            imageView!.tag = indexPath.item
            imageView!.image = self.selectAssets[indexPath.item].thumbImage
        }
        
        return cell
    }
}
