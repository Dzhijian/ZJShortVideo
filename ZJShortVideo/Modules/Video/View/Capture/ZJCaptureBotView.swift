//
//  ZJCaptureBotView.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/6.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import UIKit

protocol ZJCaptureBotViewDeleagte : NSObjectProtocol {
    /// 捕获按钮开始事件
    func zj_captureBtnStartAction(sender : UIButton?)
    /// 捕获按钮暂停事件
    func zj_captureBtnStopAction(sender : UIButton?)
    /// 删除按钮事件
    func zj_captureDeleteBtnAction(sender : UIButton?)
    /// 完成按钮事件
    func zj_captureCompleteBtnAction(sender : UIButton?)
    
    
}
class ZJCaptureBotView: UIView {

    weak var delegate : ZJCaptureBotViewDeleagte?
    
    lazy var captureBtnBgView : UIView = {
        let captureBgView = UIView.init()
        captureBgView.layer.borderColor = kCaptureBtnRedColor.withAlphaComponent(0.5).cgColor
        captureBgView.layer.borderWidth = AdaptW(6)
        captureBgView.layer.cornerRadius = AdaptW(38)
        return captureBgView
    }()
    
    lazy var captureBtn : UIButton = {
        let captureBtn = UIButton.init()
        captureBtn.backgroundColor = kCaptureBtnRedColor
        captureBtn.layer.cornerRadius = AdaptW(30);
        captureBtn.addTarget(self, action: #selector(captureBtnAction(sender:)), for: .touchUpInside)
        return captureBtn
    }()
    
    /// 删除按钮
    lazy var deleteBtn : UIButton = {
        let deleteBtn = UIButton.init()
        deleteBtn.setImage(kImageName("icon_laststep_36x36_"), for: .normal)
        deleteBtn.isHidden = true
        deleteBtn.addTarget(self, action: #selector(deleteBtnAction(sender:)), for: .touchUpInside)
        return deleteBtn
    }()
    
    /// 完成按钮
    lazy var completeBtn : UIButton = {
        let completeBtn = UIButton.init()
        completeBtn.setImage(kImageName("icoLoginCheckMarkSel"), for: .normal)
        completeBtn.addTarget(self, action: #selector(completeBtnAction(sender:)), for: .touchUpInside)
        completeBtn.isHidden = true
        return completeBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpAllView()
    }
    
    func setUpAllView() {
        addSubview(captureBtnBgView)
        addSubview(captureBtn)
        addSubview(deleteBtn)
        addSubview(completeBtn)
        
        captureBtnBgView.snp.makeConstraints { (make) in
            make.center.equalTo(self.snp.center)
            make.width.height.equalTo(AdaptW(76))
        }
        captureBtn.snp.makeConstraints { (make) in
            make.center.equalTo(captureBtnBgView.snp.center)
            make.width.height.equalTo(AdaptW(60))
        }
        deleteBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(captureBtn.snp.centerY)
            make.left.equalTo(captureBtn.snp.right).offset(Adapt(20))
            make.width.equalTo(Adapt(50))
            make.height.equalTo(Adapt(30))
        }
        
        completeBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(captureBtn.snp.centerY)
            make.left.equalTo(deleteBtn.snp.right).offset(Adapt(15))
            make.width.equalTo(Adapt(35))
            make.height.equalTo(Adapt(35))
        }
    }
    
    func captureToolBtnIsHidden(isHidden : Bool) {
        deleteBtn.isHidden = isHidden
        completeBtn.isHidden = isHidden
    }
    
    @objc func captureBtnAction(sender : UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            
            self.startRecordVideo(sender: sender)
            
        }else{
            
            self.stopRecordVideo(sender: sender)
        }
    }
    
    /// 删除事件
    @objc func deleteBtnAction(sender : UIButton){
        self.delegate?.zj_captureDeleteBtnAction(sender: sender)
    }
    /// 完成事件
    @objc func completeBtnAction(sender : UIButton){
        self.delegate?.zj_captureCompleteBtnAction(sender: sender)
    }
    /// 开始捕获视频
    func startRecordVideo(sender : UIButton) {
        UIView.animate(withDuration: 0.25, animations: {
            self.captureBtn.layer.cornerRadius = AdaptW(5)
            self.captureBtn.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            self.captureBtnBgView.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
        }) { (isFinish) in
            if isFinish { self.btnBgViewAnimation() }
            /// 开始捕获
            self.delegate?.zj_captureBtnStartAction(sender: sender)
        }
    }
    
    /// 暂停捕获
    func stopRecordVideo(sender : UIButton? = nil) {
        UIView.animate(withDuration: 0.25, animations: {
            self.captureBtn.layer.cornerRadius = AdaptW(30);
            self.captureBtn.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.captureBtnBgView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { (isFinish) in
            /// 暂停捕获
            self.delegate?.zj_captureBtnStopAction(sender: sender)
        }
    }
    
    func btnBgViewAnimation() {
        
        UIView.animate(withDuration: 0.25, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.captureBtnBgView.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
        }) { (isFinish) in
        
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
