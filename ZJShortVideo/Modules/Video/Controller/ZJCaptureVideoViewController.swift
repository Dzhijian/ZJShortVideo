//
//  ZJCaptureVideoViewController.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/2.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import UIKit

class ZJCaptureVideoViewController: ZJBaseViewController {

    /// 捕获按钮
    var captureBtn : UIButton = {
        let captureBtn = UIButton.init()
        captureBtn.setImage(kImageName("capture_icon"), for: .normal)
        return captureBtn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let videoView = ZJCaptureVideoView.init(frame: self.view.frame)
        
        view.addSubview(videoView)
        
        setUpAllView()
    }
    
    func setUpAllView() {
        view.addSubview(captureBtn)
        captureBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.bottom.equalTo(Adapt(-40))
            make.width.height.equalTo(Adapt(40))
        }
    }
}
