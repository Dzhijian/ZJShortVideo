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
    var captureBotView : ZJCaptureBotView = {
        let captureBotView = ZJCaptureBotView.init(frame: .zero)
        return captureBotView
    }()

    var closeBtn : UIButton = {
        let closeBtn = UIButton.init()
        closeBtn.setImage(kImageName("iconCameraClose_24x24_"), for: .normal)
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
        view.addSubview(captureBotView)
        view.addSubview(closeBtn)
        
        captureBotView.snp.makeConstraints { (make) in
            make.bottom.equalTo(Adapt(-30))
            make.width.equalTo(kScreenW)
            make.centerX.equalTo(self.view.snp.centerX)
            make.height.equalTo(AdaptW(100))
        }
        
        closeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(Adapt(30))
            make.left.equalTo(Adapt(20))
            make.width.height.equalTo(Adapt(32))
        }
    }
    
   
}
