//
//  ZJBaseFilter.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/27.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import UIKit

class ZJBaseFilter: GPUImageFilterGroup {
    
    let saturationFilter    = GPUImageSaturationFilter() // 饱和
    let bilateralFilter     = GPUImageBilateralFilter() // 磨皮
    let brightnessFilter    = GPUImageBrightnessFilter() // 美白
    let exposureFilter      = GPUImageExposureFilter() // 曝光
    
    override init() {
        super.init()
        //创建滤镜(设置滤镜的引来关系), 对应添加
        bilateralFilter.addTarget(brightnessFilter)
        brightnessFilter.addTarget(exposureFilter)
        exposureFilter.addTarget(saturationFilter)
        //设置默认值
        // 中心色与样品色之间距离的归一化系数。
        bilateralFilter.distanceNormalizationFactor = 5
        // 曝光范围从-10.0到10.0, 0.0为正常水平
        exposureFilter.exposure = 0
        // 亮度范围从-1.0到1.0，正常亮度为0.0
        brightnessFilter.brightness = 0
        // 饱和度范围从0.0(完全饱和)到2.0(最大饱和度)，1.0为正常水平
        saturationFilter.saturation = 1.0
        //设置滤镜起点 终点的filter
        self.initialFilters = [bilateralFilter]
        self.terminalFilter = saturationFilter
    }
    
}
