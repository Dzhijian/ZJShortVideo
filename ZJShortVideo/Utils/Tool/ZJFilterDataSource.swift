//
//  ZJFilterDataSource.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/23.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import Foundation
import GPUImage

func getFilterDataSource() -> [GPUImageFilterGroup] {
    
    let amatorka        = GPUImageAmatorkaFilter.init()
    let missEtikate     = GPUImageMissEtikateFilter.init()
//    let sepia           = GPUImageSepiaFilter.init()
//    let toon            = GPUImageToonFilter.init()
    let softElegance    = GPUImageSoftEleganceFilter.init()
//    let sket            = GPUImageSketchFilter.init()
    
    let dataSource      = [amatorka,missEtikate,softElegance]
//    dataSource.append()
    return dataSource 
}
