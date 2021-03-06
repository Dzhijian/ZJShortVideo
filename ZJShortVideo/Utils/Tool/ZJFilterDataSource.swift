//
//  ZJFilterDataSource.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/23.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import Foundation
import GPUImage

func getFilterDataSource() -> [ZJFilterModel] {
    var dataArray : [ZJFilterModel] = []
    for style in ZJGPUFilterStyle.allCases {
        let filter = style.instance
        let filterImage = filter.image(byFilteringImage: kImageName("shortVide_icon"))
        let model = ZJFilterModel.init()
        model.filterIcon = filterImage
        model.filterTitle = style.title
        model.filter = filter
        dataArray.append(model)
    }
    
//    let amatorka        = GPUImageAmatorkaFilter.init()
//    let missEtikate     = GPUImageMissEtikateFilter.init()
////    let sepia           = GPUImageSepiaFilter.init()
////    let toon            = GPUImageToonFilter.init()
//    let softElegance    = GPUImageSoftEleganceFilter.init()
//    let sket            = GPUImageSketchFilter.init()
//
//    let dataSource      = [amatorka,missEtikate,softElegance]
////    dataSource.append()
    return dataArray
}
