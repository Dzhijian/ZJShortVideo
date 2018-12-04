//
//  ZJAddVideoViewController.swift
//  ZJShortVideo
//#imageLiteral(resourceName: "appicon.png")
//  Created by 邓志坚 on 2018/12/2.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import AssetsLibrary

class ZJAddVideoViewController: ZJBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let showbtn = UIButton.init()
        showbtn.setTitle("打开相机", for: .normal)
        showbtn.setTitleColor(kWhiteColor, for: .normal)
        showbtn.backgroundColor = kOrangeColor
        showbtn.layer.cornerRadius = 5
        showbtn.addTarget(self, action: #selector(presenVC), for: .touchUpInside)
        
        view.addSubview(showbtn)
        showbtn.snp.makeConstraints { (make) in
            make.center.equalTo(self.view.snp.center)
            make.width.equalTo(Adapt(120))
            make.height.equalTo(AdaptW(45))
        }
        
    }
    
    
    
    @objc func presenVC() {

        self.present(ZJCaptureVideoViewController(), animated: true, completion: nil)
    }
    
}
