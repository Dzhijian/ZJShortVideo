//
//  ZJFontsMacor.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/2.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import UIKit

func kFontSize(name: String? = nil, value: CGFloat) -> UIFont {
    if name != nil {
        return UIFont(name: name!, size: value)!
    }
    return UIFont.systemFont(ofSize: AdaptW(value))
}

func kFontBoldSize(value: CGFloat) -> UIFont {
    return UIFont.boldSystemFont(ofSize: AdaptW(value))
}

