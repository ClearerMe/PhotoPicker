//
//  PhotoPickerGroupViewController.swift
//  PhotoPicker
//
//  Created by  lifirewolf on 16/3/4.
//  Copyright © 2016年  lifirewolf. All rights reserved.
//

import UIKit
import AssetsLibrary

class PhotoPickerGroupViewController: UIViewController {

    var delegate: PhotoPickerViewControllerDelegate!
    var status: PickerViewShowStatus!
    var maxCount = 0
    // 记录选中的值
    var selectAsstes = [PhotoAssets]()
    // 置顶展示图片
    var topShowPhotoPicker = false
    
    var collectionVc: PhotoPickerAssetsViewController!
    
    var tableView: UITableView!
    var groups: [PhotoPickerGroup]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "选择相册"
        
        setupButtons()
        
        let author = ALAssetsLibrary.authorizationStatus()
        if author == ALAuthorizationStatus.Restricted || author == ALAuthorizationStatus.Denied {
            // 判断没有权限获取用户相册的话，就提示个View
            let lockView = UIImageView()
            lockView.image = SourceUtil.imageFromBundleName(ImageName.lock)
            lockView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - 200)
            lockView.contentMode = UIViewContentMode.Center
            view.addSubview(lockView)
            
            let lockLbl = UILabel()

            lockLbl.text = PICKER_PowerBrowserPhotoLibirayText
            lockLbl.numberOfLines = 0
            lockLbl.textAlignment = NSTextAlignment.Center
            lockLbl.frame = CGRect(x: 20, y: 0, width: view.frame.size.width - 40, height: view.frame.size.height)
            view.addSubview(lockLbl)
            
        } else {
            tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.delegate = self
            view.addSubview(tableView)
            tableView.registerClass(PhotoPickerGroupTableViewCell.self, forCellReuseIdentifier: PhotoPickerGroupTableViewCell.self.description())
            
            let views = ["tableView": tableView]
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[tableView]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[tableView]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
            
            getImgs()
        }
    }
    
    func setupButtons() {
        let barItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Done, target: self, action: "back")
        navigationItem.rightBarButtonItem = barItem
    }
    
    func getImgs() {
        let datas = PhotoPickerDatas.defaultPicker()
        
        if status == .Video {
            // 获取所有的图片URLs
            datas.getAllGroupWithVideos { groups in
                
                var tmp = [PhotoPickerGroup]()
                for g in groups {
                    if g.groupName == "Photo Library" {
                        continue
                    }
                    tmp.append(g)
                }
                groups = tmp
                
                self.jump2StatusVc()
                
                self.tableView.dataSource = self
                self.tableView.reloadData()
            }
            
        } else {
            // 获取所有的图片URLs
            datas.getAllGroupWithPhotos { groups in
                var tmp = [PhotoPickerGroup]()
                for g in groups {
                    if g.groupName == "Photo Library" {
                        continue
                    }
                    tmp.append(g)
                }
                self.groups = tmp
                
                self.jump2StatusVc()
                
                self.tableView.dataSource = self
                self.tableView.reloadData()
            }
        }
    }
    
    func jump2StatusVc() {
        // 如果是相册
        var gp: PhotoPickerGroup?
        for group in groups {
            if (status == .CameraRoll || status == .Video) && (group.groupName == "Camera Roll" || group.groupName == "相机胶卷") {
                gp = group
                break
                
            } else if status == .SavePhotos && (group.groupName == "Saved Photos" || group.groupName == "保存相册") {
                gp = group
                break
                
            } else if status == .SavePhotos && (group.groupName == "Stream" || group.groupName == "我的照片流") {
                gp = group
                break
            }
        }
        
        if gp == nil {
            return
        }
        
        let assetsVc = PhotoPickerAssetsViewController()
        assetsVc.selectPickerAssets = selectAsstes
        assetsVc.assetsGroup = gp
        assetsVc.groupVc = self
        assetsVc.maxCount = maxCount
        navigationController?.pushViewController(assetsVc, animated: false)
    }
    
    func back() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension PhotoPickerGroupViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(PhotoPickerGroupTableViewCell.self.description(), forIndexPath: indexPath) as! PhotoPickerGroupTableViewCell
        cell.group = groups[indexPath.row]
        
        return cell
    }
}

extension PhotoPickerGroupViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let group = groups[indexPath.row]
        let assetsVc = PhotoPickerAssetsViewController()
        
        assetsVc.selectPickerAssets = selectAsstes
        assetsVc.groupVc = self
        assetsVc.assetsGroup = group
        assetsVc.maxCount = maxCount
        navigationController?.pushViewController(assetsVc, animated: true)
    }
}
