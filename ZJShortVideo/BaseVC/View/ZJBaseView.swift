//
//  ZJBaseView.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/13.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import UIKit

class ZJBaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        zj_initView(frame: frame)
        
    }
    
    public func zj_initView(frame : CGRect) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
