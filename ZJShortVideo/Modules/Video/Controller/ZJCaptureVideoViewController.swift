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

    var closeBtn : UIButton = {
        let closeBtn = UIButton.init()
        closeBtn.setImage(kImageName("close_icon"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeBtnAction), for: .touchUpInside)
        return closeBtn
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let videoView = ZJCaptureVideoView.init(frame: self.view.frame)

        view.addSubview(videoView)
        setUpAllView()
    }
    
    @objc func closeBtnAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpAllView() {
        view.addSubview(captureBtn)
        view.addSubview(closeBtn)
        
        captureBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.bottom.equalTo(Adapt(-40))
            make.width.height.equalTo(Adapt(50))
        }
        
        closeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(Adapt(30))
            make.left.equalTo(Adapt(20))
            make.width.height.equalTo(Adapt(32))
        }
    }
    
   
}
