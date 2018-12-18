//
//  ZJCaptureFilterCell.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/18.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import UIKit

class ZJCaptureFilterCell: ZJBaseCollectionCell {
 
    lazy var titleLab : UILabel = {
        let lab = UILabel.init()
        lab.textColor = kWhiteColor;
        lab.font = UIFont.systemFont(ofSize: 15)
        return lab
    }()
    override func zj_initWithView() {
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = true
        addSubview(titleLab)
        titleLab.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
}
