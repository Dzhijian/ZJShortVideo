//
//  ZJRootViewController.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/2.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import UIKit

class ZJRootViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpChildVC(vc: ZJHomeViewController(),title: "ShortVideo", imgName: "video_icon", seleImgName: "video_icon")
        setUpChildVC(vc: ZJAddVideoViewController(),title: "", imgName: "add_video_icon", seleImgName: "add_video_icon")
        setUpChildVC(vc: ZJProfileViewController(),title: "我的", imgName: "profile_icon", seleImgName: "profile_icon")
        self.tabBar.tintColor = kColorFromHexString(rgbString: "#d4237a")
    }
    
    func setUpChildVC(vc: UIViewController,title: String, imgName: String,seleImgName: String){
        
        vc.tabBarItem.image = kImageName(imgName)
        vc.tabBarItem.selectedImage = kImageName(seleImgName)
        vc.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        vc.title = ""
        let nav = ZJNavigationController.init(rootViewController: vc)
        nav.navigationItem.title = title
        self.addChild(nav)
    }
}
