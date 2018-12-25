//
//  ZJFilterModel.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/24.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import UIKit
/*
 let amatorka        = GPUImageAmatorkaFilter.init()
 let missEtikate     = GPUImageMissEtikateFilter.init()
 //    let sepia           = GPUImageSepiaFilter.init()
 //    let toon            = GPUImageToonFilter.init()
 let softElegance    = GPUImageSoftEleganceFilter.init()
 */
enum ZJGPUFilterStyle : String ,CaseIterable {
//    case sketch         = "GPUImageSketchFilter"
//    case toon           = "GPUImageToonFilter"
//    case smoothToon     = "GPUImageSmoothToonFilter"
    case amatorka       = "GPUImageAmatorkaFilter"
    case missEtikate    = "GPUImageMissEtikateFilter"
    case softElegance   = "GPUImageSoftEleganceFilter"
    var title: String {
        switch self {
//        case .sketch:           return "sketch"
//        case .toon:             return "toon"
//        case .smoothToon:       return "sToon"
        case .amatorka:         return "amatorka"
        case .missEtikate:      return "missEtikate"
        case .softElegance:     return "softElegance"
        }
    }
    
    var instance: GPUImageFilterGroup {
        let filterClass: AnyClass = NSClassFromString(self.rawValue)!
        let realClass = filterClass as! GPUImageFilterGroup.Type
        return realClass.init()
    }
}

class ZJFilterModel: NSObject {
    /// 滤镜类型
    var filterClassName : NSString?
    /// 滤镜名称
    var filterTitle : String?
    /// 图片
    var filterIcon : UIImage?
    /// 滤镜值值
    var filterValue : Float?
    /// 滤镜类型
    var filter : GPUImageFilterGroup?
    /// 是否选中状态
    var isSelect : Bool?
    override init() {
        super.init()
        
    }
    
    
}
