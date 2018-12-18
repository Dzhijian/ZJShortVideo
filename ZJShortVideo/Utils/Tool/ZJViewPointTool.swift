
//
//  ZJViewPointTool.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/18.
//  Copyright © 2018 邓志坚. All rights reserved.
//
import UIKit
import Foundation
///  将UI的坐标转换成相机坐标
func convertToPointOfInterestFromViewCoordinates(view : UIView , viewCoordinates : CGPoint) -> CGPoint {
    
    var pointOfInterest = CGPoint(x: 0.5, y: 0.5)
    let frameSize: CGSize = view.frame.size
    let apertureSize = CGSize(width: 1280, height: 720) //设备采集分辨率
    let point: CGPoint = viewCoordinates
    let apertureRatio: CGFloat = apertureSize.height / apertureSize.width
    let viewRatio: CGFloat = frameSize.width / frameSize.height
    var xc: CGFloat = 0.5
    var yc: CGFloat = 0.5
    if viewRatio > apertureRatio {
        let y2: CGFloat = frameSize.height
        let x2: CGFloat = frameSize.height * apertureRatio
        let x1: CGFloat = frameSize.width
        let blackBar: CGFloat = (x1 - x2) / 2
        if point.x >= blackBar && point.x <= blackBar + x2 {
            xc = point.y / y2
            yc = 1.0 - ((point.x - blackBar) / x2)
        }
    } else {
        let y2: CGFloat = frameSize.width / apertureRatio
        let y1: CGFloat = frameSize.height
        let x2: CGFloat = frameSize.width
        let blackBar: CGFloat = (y1 - y2) / 2
        if point.y >= blackBar && point.y <= blackBar + y2 {
            xc = (point.y - blackBar) / y2
            yc = 1.0 - (point.x / x2)
        }
    }
    pointOfInterest = CGPoint(x: xc, y: yc)
    
    return pointOfInterest
}
