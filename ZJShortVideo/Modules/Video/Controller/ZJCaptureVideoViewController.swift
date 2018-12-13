//
//  ZJCaptureVideoViewController.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/2.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import UIKit

class ZJCaptureVideoViewController: ZJBaseViewController {
    /// 视频捕获的 View
    lazy var captureView : ZJCaptureVideoView = {
        let videoView = ZJCaptureVideoView.init(frame: self.view.frame)
        videoView.delegate = self
        return videoView
    }()
    
    /// 右边的按钮
    lazy var rightToolView : ZJCaptureRightToolView = {
        let rightView = ZJCaptureRightToolView.init(frame: .zero)
        rightView.delegate = self
        return rightView
    }()
    /// 关闭按钮
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(captureView)
        setUpAllView()
    }
    
    @objc func closeBtnAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpAllView() {
        
        view.addSubview(closeBtn)
        view.addSubview(rightToolView)
        
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


// MARK: - ZJCaptureVideoViewDelegate
extension ZJCaptureVideoViewController : ZJCaptureVideoViewDelegate{
    func zj_captureViewVideoCompleteAction() {
        self.navigationController?.pushViewController(ZJEditVideoViewController(), animated: true)
    }
}


// MARK: - ZJCaptureRightToolViewDelegate
extension ZJCaptureVideoViewController : ZJCaptureRightToolViewDelegate {
    
    func zj_captureRightToolViewBtnAction(btnType : ZJRightToolBtnType) {
        switch btnType {
        case .overTurn:
            print("翻转")
            self.captureView.changeDevice()
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
