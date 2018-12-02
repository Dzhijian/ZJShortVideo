//
//  ZJBaseCollectionCell.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/2.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import UIKit

class ZJBaseCollectionCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = kWhiteColor
        zj_initWithView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func zj_initWithView() {
        
        
    }
    
    public class func itemHeight() -> CGSize {
        return CGSize(width: 0.0, height: 0.0)
    }
    
    public class func itemHeightWithModel(model : Any) -> CGSize {
        return CGSize(width: 0.0, height: 0.0)
    }
    
    public class func identifier() -> String {
        
        let name: AnyClass! = object_getClass(self)
        return NSStringFromClass(name)
        
    }
}
