//
//  ViewController.swift
//  PhotoPicker
//
//  Created by  lifirewolf on 16/3/4.
//  Copyright © 2016年  lifirewolf. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func pickPhoto(sender: AnyObject) {
        let pickerVc = PhotoPickerViewController()
        // 默认显示相册里面的内容SavePhotos
        // 最多能选9张图片
        pickerVc.maxCount = 9
//        pickerVc.selectAsstes = assets
        pickerVc.status = PickerViewShowStatus.CameraRoll
        pickerVc.delegate = self
        
        presentViewController(pickerVc, animated: true, completion: nil)
    }

}

extension ViewController: PhotoPickerViewControllerDelegate {
    func pickerViewControllerDoneAssets(assets: [PhotoAssets]) {
//        self.assets = assets
        
        self.imageView.stopAnimating()
        if assets.count == 1 { // 单张图片
            self.imageView.image = assets.last!.thumbImage
            
        } else { // 多张图片
            var images = [UIImage]()
            for photo in assets {
                images.append(photo.thumbImage)
            }
            self.imageView.animationImages = images
            self.imageView.animationDuration = 0.6
            self.imageView.startAnimating()
        }
    }
}
