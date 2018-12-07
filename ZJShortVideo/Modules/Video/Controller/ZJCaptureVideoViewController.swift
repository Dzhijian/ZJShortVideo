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
    lazy var captureBotView : ZJCaptureBotView = {
        let captureBotView = ZJCaptureBotView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: AdaptW(100)))
        return captureBotView
    }()
    lazy var rightToolView : ZJCaptureRightToolView = {
        let rightView = ZJCaptureRightToolView.init(frame: .zero)
        rightView.delegate = self
        return rightView
    }()
    var closeBtn : UIButton = {
        let closeBtn = UIButton.init()
        closeBtn.setImage(kImageName("iconCameraClose_24x24_"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeBtnAction), for: .touchUpInside)
        return closeBtn
    }()
    
    // 隐藏状态栏
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
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
        view.addSubview(rightToolView)
        
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
        
        rightToolView.snp.makeConstraints { (make) in
            make.top.equalTo(Adapt(15))
            make.right.equalTo(Adapt(-10))
            make.width.equalTo(Adapt(60))
            make.height.equalTo(Adapt(245))
        }
    }
}


// MARK: - ZJCaptureRightToolViewDelegate
extension ZJCaptureVideoViewController : ZJCaptureRightToolViewDelegate {
    
    func zj_captureRightToolViewBtnAction(btnType : ZJRightToolBtnType) {
        switch btnType {
        case .overTurn:
            print("翻转")
        case .speed:
            print("快慢速度")
        case .filter:
            print("美化")
        case .timeDown:
            print("倒计时")
        default: break
            
        }
    }
}
