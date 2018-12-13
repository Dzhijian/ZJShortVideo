//
//  ZJVideoProgressView.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/13.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import UIKit

class ZJVideoProgressView: ZJBaseView {

    fileprivate lazy var progressView : UIProgressView = {
        let progressView = UIProgressView.init()
        progressView.trackTintColor = kRGBAColor(100, 100, 100, 0.5)
        progressView.progressTintColor = kOrangeColor
        progressView.layer.cornerRadius = Adapt(4)
        progressView.layer.masksToBounds = true
        return progressView;
    }()
    
    lazy var lineArray : NSMutableArray = {
        let lineArray = NSMutableArray.init()
        return lineArray
    }()
    
    override func zj_initView(frame: CGRect) {
        
        addSubview(progressView)
        
        progressView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
    }
    
    
    /// 设置进度
    func zj_setProgress(value : Float) {
        
        self.progressView.progress = value
        
    }

    /// 添加 layer
    func zj_addlineLayer(value : Float) {
        let lineLayer : CALayer = CALayer.init()
        lineLayer.backgroundColor = kWhiteColor.cgColor;
        lineLayer.frame = CGRect(x:CGFloat(value) * self.progressView.frame.size.width, y: 0, width: 2, height: self.progressView.frame.size.height)
        print(CGFloat(value))
        self.progressView.layer.addSublayer(lineLayer)
        lineArray.add(lineLayer)
        
    }
}
