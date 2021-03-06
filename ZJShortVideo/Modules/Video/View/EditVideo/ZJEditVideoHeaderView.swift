
//
//  ZJEditVideoHeaderView.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/2.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import UIKit

/// 按钮枚举
enum HeaderViewBtnActionType {
    
    case HeaderViewBtnActionTypeCancel    // 取消事件
    case HeaderViewBtnActionTypeConfirm  // 完成事件
}

protocol ZJEditVideoHeaderViewDelegate : NSObjectProtocol{
    func zj_headerToolBtnAction(actionType : HeaderViewBtnActionType)
}

class ZJEditVideoHeaderView: UIView {

    weak var delegate : ZJEditVideoHeaderViewDelegate?
    
    var actionType : HeaderViewBtnActionType?
    
    lazy var cancelBtn : UIButton = {
        let cancelBtn = UIButton.init()
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(kWhiteColor, for: .normal)
        cancelBtn.titleLabel?.font = kFontSize(value: 15)
        cancelBtn.tag = kBaseTarget + 1
        cancelBtn.addTarget(self, action: #selector(btnAction(sender:)), for: .touchUpInside)
        return cancelBtn
    }()
    lazy var confirmBtn : UIButton = {
        let confirmBtn = UIButton.init()
        confirmBtn.setTitle("确认", for: .normal)
        confirmBtn.setTitleColor(kWhiteColor, for: .normal)
        confirmBtn.titleLabel?.font = kFontSize(value: 15)
        confirmBtn.tag = kBaseTarget + 2
        confirmBtn.addTarget(self, action: #selector(btnAction(sender:)), for: .touchUpInside)
        return confirmBtn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpAllView()
    }
    
    func setUpAllView() {
        self.addSubview(cancelBtn)
        self.addSubview(confirmBtn)
        
        cancelBtn.snp.makeConstraints { (make) in
            make.left.equalTo(Adapt(15))
            make.bottom.equalTo(Adapt(-7))
            make.width.equalTo(Adapt(60))
            make.height.equalTo(Adapt(30))
        }
        
        confirmBtn.snp.makeConstraints { (make) in
            make.right.equalTo(Adapt(-15))
            make.bottom.equalTo(Adapt(-7))
            make.width.equalTo(Adapt(60))
            make.height.equalTo(Adapt(30))
        }
    }
    
    @objc func btnAction(sender : UIButton) {
        if sender.tag - kBaseTarget == 1 {
            print("cancel")
            self.actionType = HeaderViewBtnActionType.HeaderViewBtnActionTypeCancel
        } else if sender.tag - kBaseTarget == 2 {
            print("confirm")
            self.actionType = HeaderViewBtnActionType.HeaderViewBtnActionTypeConfirm
        }
        
        self.delegate?.zj_headerToolBtnAction(actionType: self.actionType!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
