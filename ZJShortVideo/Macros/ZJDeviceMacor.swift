//
//  ZJDeviceMacor.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/2.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher


let kScreenW = UIScreen.main.bounds.size.width
let kScreenH = UIScreen.main.bounds.size.height

// 判断是否为 iPhone X
let kisIphoneX = kScreenH >= 812 ? true : false

// 自定义索引值
let kBaseTarget : Int = 1000
// 宽度比
let kWidthRatio = kScreenW / 375.0
// 高度比
let kHeightRatio = kScreenH / 667.0

// 按比例自适应
func Adapt(_ value : CGFloat) -> CGFloat {
    return AdaptW(value)
}
// 自适应宽度
func AdaptW(_ value : CGFloat) -> CGFloat {
    return ceil(value) * kWidthRatio
}
// 自适应高度
func AdaptH(_ value : CGFloat) -> CGFloat {
    return ceil(value) * kHeightRatio
}

func kImageName(_ name : String) -> UIImage {
    return UIImage(named: name) ?? UIImage.init()
}
