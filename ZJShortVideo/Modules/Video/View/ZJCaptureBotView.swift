//
//  ZJCaptureBotView.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/6.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import UIKit

class ZJCaptureBotView: UIView {

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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(captureBtnBgView)
        addSubview(captureBtn)
        
        captureBtnBgView.snp.makeConstraints { (make) in
            make.center.equalTo(self.snp.center)
            make.width.height.equalTo(AdaptW(76))
        }
        captureBtn.snp.makeConstraints { (make) in
            make.center.equalTo(captureBtnBgView.snp.center)
            make.width.height.equalTo(AdaptW(60))
        }
    }
    
    @objc func captureBtnAction(sender : UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            
            UIView.animate(withDuration: 0.25, animations: {
                self.captureBtn.layer.cornerRadius = AdaptW(5)
                self.captureBtn.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                self.captureBtnBgView.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
            }) { (isFinish) in
                if isFinish { self.btnBgViewAnimation() }
            }
            
//            UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .curveLinear], animations: {
//                self.captureBtnBgView.layer.borderWidth = AdaptW(3);
//            }) { (isFinish) in
//                 self.captureBtnBgView.layer.borderWidth = AdaptW(6)
//            }
            
        }else{
            
            UIView.animate(withDuration: 0.25, animations: {
                self.captureBtn.layer.cornerRadius = AdaptW(30);
                self.captureBtn.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.captureBtnBgView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }) { (isFinish) in
                
            }
        }
    }
    
    func btnBgViewAnimation() {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.captureBtnBgView.layer.borderWidth = AdaptW(3);
        }) { (isFinish) in
            self.captureBtnBgView.layer.borderWidth = AdaptW(6)
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
