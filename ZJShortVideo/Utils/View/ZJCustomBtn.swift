//
//  ZJCustomBtn.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/7.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import UIKit
/// 图片位置
enum ZJBtnImageAlignment {
    case left,right,top,bottom
}
class ZJCustomBtn: UIButton {
    
    
    var spaceBetweenTitleAndImage : CGFloat = 2
    var imageAlignment : ZJBtnImageAlignment = .left

    override func layoutSubviews() {
        super.layoutSubviews()
        let space = spaceBetweenTitleAndImage
    
        var imageEdgeInset = UIEdgeInsets.zero
        var labelEdgeInset = UIEdgeInsets.zero
        let imageWith = self.imageView?.frame.size.width
        let imageHeight = self.imageView?.frame.size.height
        let labelWidth = (self.titleLabel?.frame.size.width)!
        let labelHeight = (self.titleLabel?.frame.size.height)!

        switch self.imageAlignment {
        case .top:
            imageEdgeInset = UIEdgeInsets(top: -labelHeight-space/2.0, left: 0, bottom: 0, right: -labelWidth)
            labelEdgeInset = UIEdgeInsets(top: 0, left: -imageWith!, bottom: -imageHeight!-space/2.0, right: 0)
            self.titleLabel?.textAlignment = .center
        case .left:
            imageEdgeInset = UIEdgeInsets(top: 0, left: -space/2.0, bottom: 0, right: space/2.0);
            labelEdgeInset = UIEdgeInsets(top: 0, left: space/2.0, bottom: 0, right: -space/2.0);
        case .bottom:
            imageEdgeInset = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight-space/2.0, right: -labelWidth)
            labelEdgeInset = UIEdgeInsets(top: -imageHeight!-space/2.0, left: -imageWith!, bottom: 0, right: 0)
            self.titleLabel?.textAlignment = .center
        case .right:
            imageEdgeInset = UIEdgeInsets(top: 0, left: labelWidth+space/2.0, bottom: 0, right: -labelWidth-space/2.0)
            labelEdgeInset = UIEdgeInsets(top: 0, left: -imageWith!-space/2.0, bottom: 0, right: imageWith!+space/2.0)
        }
        self.titleEdgeInsets = labelEdgeInset
        self.imageEdgeInsets = imageEdgeInset
    }
    
}
