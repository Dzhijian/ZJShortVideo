//
//  ZJEditVideoFooterView.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/2.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import UIKit

class ZJEditVideoFooterView: UIView {

    /// 捕获按钮
    var captureBtn : UIButton = {
        let captureBtn = UIButton.init()
        captureBtn.setImage(kImageName("capture_icon"), for: .normal)
        return captureBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpAllView()
    }
    
    func setUpAllView() {
        self.addSubview(captureBtn)
        captureBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(Adapt(10))
            make.width.height.equalTo(Adapt(40))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
