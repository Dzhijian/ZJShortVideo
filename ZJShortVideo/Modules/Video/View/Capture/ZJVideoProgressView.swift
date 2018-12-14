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
    lazy var valueArray : NSMutableArray = {
        let valueArray = NSMutableArray.init()
        return valueArray
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
    func zj_addlineLayer(value: Float, newValue: Float) {
        let lineView : UIView = UIView.init()
        lineView.backgroundColor = kWhiteColor;
        lineView.frame = CGRect(x:CGFloat(value) * self.progressView.frame.size.width, y: 0, width: 2, height: self.progressView.frame.size.height)
        print(CGFloat(value))
        self.progressView.addSubview(lineView)
        lineArray.add(lineView)
        print("newValue:" + "\(newValue)")
        valueArray.add(newValue)
    }
    
    /// 删除
    func zj_deleteLineAndValue() {
        
        // 删除分割线
        for lineView in self.progressView.subviews {
            let line : UIView = lineArray.lastObject as! UIView
            if line.isEqual(lineView) {
                lineArray.removeLastObject()
                lineView.removeFromSuperview()
            }
        }
        let value : Float = valueArray.lastObject as! Float
        // 减少对应的进度
        self.progressView.setProgress(self.progressView.progress - value, animated: true)
        valueArray.removeLastObject()
        
        super.layoutIfNeeded()
    }
}
