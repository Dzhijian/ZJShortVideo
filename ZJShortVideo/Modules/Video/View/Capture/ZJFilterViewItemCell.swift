//
//  ZJFilterViewItemCell.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/19.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import UIKit

class ZJFilterViewItemCell: ZJBaseCollectionCell {

    fileprivate lazy var icon : UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    fileprivate lazy var titleLab : UILabel = {
        let titleLab = UILabel.init()
        titleLab.textColor = kRGBAColor(220, 220, 220)
        titleLab.font = kFontSize(value: 13)
        titleLab.textAlignment = .center
        return titleLab
    }()
    
    override func zj_initWithView() {
        contentView.backgroundColor = kClearColor
        self.backgroundColor = kClearColor
        contentView.addSubview(icon)
        contentView.addSubview(titleLab)
        icon.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.width.equalTo(self.frame.size.width)
        }
        
        titleLab.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(0)
            make.top.equalTo(icon.snp.bottom)
        }
        
    }
    
    
    func configIconAndTitle() {
        
    }
    

}
