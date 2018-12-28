//
//  ZJAmaroFilter.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/24.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import UIKit

class ZJAmaroFilter: ZJBaseFilter {

    let amatorka    = GPUImageAmatorkaFilter.init()
    
    override init() {
        super.init()
        self.addTarget(amatorka)
        self.initialFilters.append(amatorka)
    }
    
    
}
