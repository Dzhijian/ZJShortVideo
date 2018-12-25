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
        icon.layer.cornerRadius = Adapt(30)
        icon.layer.masksToBounds = true
        return icon
    }()
    fileprivate lazy var seleIcon : UIImageView = {
        let seleIcon = UIImageView.init()
        seleIcon.contentMode = .center
        seleIcon.layer.cornerRadius = Adapt(30)
        seleIcon.layer.masksToBounds = true
        seleIcon.backgroundColor = kRGBAColor(99, 99, 99, 0.5)
        seleIcon.isHidden = true
        seleIcon.image = kImageName("icCameraDetermine_24x24_")
        return seleIcon
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
        contentView.addSubview(seleIcon)
        
        contentView.addSubview(titleLab)
        icon.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(Adapt(60))
        }
        seleIcon.snp.makeConstraints { (make) in
            make.center.equalTo(icon.snp.center)
            make.width.height.equalTo(Adapt(60))
        }
        titleLab.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(0)
            make.top.equalTo(icon.snp.bottom)
        }
        
    }
    
    func configFilterItem(filterModel : ZJFilterModel) {
        icon.image      = filterModel.filterIcon
        titleLab.text   = filterModel.filterTitle
    }

    func configSeleImageHidden(isHidden : Bool)  {
        seleIcon.isHidden = isHidden
    }
}
