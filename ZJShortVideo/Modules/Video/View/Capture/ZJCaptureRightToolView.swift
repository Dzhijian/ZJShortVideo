//
//  ZJCaptureRightToolView.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/7.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import UIKit

enum ZJRightToolBtnType {
    case overTurn,speed,filter,timeDown,none
}

protocol ZJCaptureRightToolViewDelegate : NSObjectProtocol {
//    optional
    
    func zj_captureRightToolViewBtnAction(btnType : ZJRightToolBtnType)
}

class ZJCaptureRightToolView: UIView {
    
    var toolType : ZJRightToolBtnType = .none
    
    weak var delegate : ZJCaptureRightToolViewDelegate?
    // 翻转
    lazy var overturnBtn : ZJCustomBtn = {
        let overturn = ZJCustomBtn.init(frame: CGRect(x: 0, y: 0, width: Adapt(0), height: AdaptH(0)))
        overturn.imageAlignment = .top
        overturn.setTitle("翻转", for: .normal)
        overturn.setTitleColor(UIColor.white, for: .normal)
        overturn.setImage(kImageName("icon_reversal_front_40x40_"), for: .normal)
        overturn.titleLabel?.font = kFontSize(value: 13)
        overturn.spaceBetweenTitleAndImage = 0
        overturn.adjustsImageWhenHighlighted = false
        overturn.tag = kBaseTarget + 1
        overturn.addTarget(self, action: #selector(btnAction(sender:)), for: .touchUpInside)
        return overturn
    }()
    /// 快慢速
    lazy var speedBtn : ZJCustomBtn = {
        let speedBtn = ZJCustomBtn.init(frame: CGRect(x: 0, y: 0, width: Adapt(0), height: AdaptH(0)))
        speedBtn.imageAlignment = .top
        speedBtn.setTitle("快慢速", for: .normal)
        speedBtn.setTitleColor(UIColor.white, for: .normal)
        speedBtn.setImage(kImageName("icShootingSpeedPlanCOff_40x40_"), for: .normal)
        speedBtn.titleLabel?.font = kFontSize(value: 13)
        speedBtn.spaceBetweenTitleAndImage = 0
        speedBtn.adjustsImageWhenHighlighted = false
        speedBtn.tag = kBaseTarget + 2
        speedBtn.addTarget(self, action: #selector(btnAction(sender:)), for: .touchUpInside)
        return speedBtn
    }()
    /// 美化
    lazy var filterBtn : ZJCustomBtn = {
        let filterBtn = ZJCustomBtn.init(frame: CGRect(x: 0, y: 0, width: Adapt(0), height: AdaptH(0)))
        filterBtn.imageAlignment = .top
        filterBtn.setTitle("美化", for: .normal)
        filterBtn.setTitleColor(UIColor.white, for: .normal)
        filterBtn.setImage(kImageName("iconFilterB_40x40_"), for: .normal)
        filterBtn.titleLabel?.font = kFontSize(value: 13)
        filterBtn.spaceBetweenTitleAndImage = 0
        filterBtn.adjustsImageWhenHighlighted = false
        filterBtn.tag = kBaseTarget + 3
        filterBtn.addTarget(self, action: #selector(btnAction(sender:)), for: .touchUpInside)
        return filterBtn
    }()
    /// 倒计时
    lazy var timeDownBtn : ZJCustomBtn = {
        let timeDownBtn = ZJCustomBtn.init(frame: CGRect(x: 0, y: 0, width: Adapt(0), height: AdaptH(0)))
        timeDownBtn.imageAlignment = .top
        timeDownBtn.setTitle("倒计时", for: .normal)
        timeDownBtn.setTitleColor(UIColor.white, for: .normal)
        timeDownBtn.setImage(kImageName("iconStopwatch2_40x40_"), for: .normal)
        timeDownBtn.titleLabel?.font = kFontSize(value: 13)
        timeDownBtn.adjustsImageWhenHighlighted = false
        timeDownBtn.spaceBetweenTitleAndImage = 0
        timeDownBtn.tag = kBaseTarget + 4
        timeDownBtn.addTarget(self, action: #selector(btnAction(sender:)), for: .touchUpInside)
        return timeDownBtn
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpAllView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpAllView() {
        addSubview(self.overturnBtn)
        addSubview(self.speedBtn)
        addSubview(self.filterBtn)
        addSubview(self.timeDownBtn)
        self.overturnBtn.snp.makeConstraints { (make) in
            make.top.equalTo(Adapt(10))
            make.right.equalTo(0)
            make.width.equalTo(Adapt(60))
            make.height.equalTo(Adapt(60))
        }
        
        self.speedBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.overturnBtn.snp.bottom).offset(AdaptW(5))
            make.width.height.equalTo(AdaptW(60))
            make.right.equalTo(0)
        }
        
        self.filterBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.speedBtn.snp.bottom).offset(AdaptW(5))
            make.width.height.equalTo(AdaptW(60))
            make.right.equalTo(0)
        }
        
        self.timeDownBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.filterBtn.snp.bottom).offset(AdaptW(5))
            make.width.height.equalTo(AdaptW(60))
            make.right.equalTo(0)
        }
        
    }
    
    @objc func btnAction(sender : UIButton) {
        
        switch sender.tag - kBaseTarget {
        case 1:
            self.toolType = .overTurn
        case 2:
            self.toolType = .speed
        case 3:
            self.toolType = .filter
        case 4:
            self.toolType = .timeDown
        default:
            self.toolType = .none
        }
        self.delegate?.zj_captureRightToolViewBtnAction(btnType: self.toolType)
    }

}
