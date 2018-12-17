
//
//  ZJCaptureFilterView.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/17.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import UIKit

fileprivate let kCellID = "ZJCaptureFilterCell"
class ZJCaptureFilterView: UIView {
    
    var dataSource = NSMutableArray()
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: self.bounds.size.width, height: self.bounds.size.height)
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.register(ZJCaptureFilterCell.self, forCellWithReuseIdentifier: ZJCaptureFilterCell.identifier())
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = UIColor.clear
        return collectionView;
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpAllView()
    }
    
    func setUpAllView() {
        addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension ZJCaptureFilterView : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ZJCaptureFilterCell = collectionView.dequeueReusableCell(withReuseIdentifier: ZJCaptureFilterCell.identifier(), for: indexPath) as! ZJCaptureFilterCell
        cell.titleLab.text = "\(indexPath.item)"
        return cell;
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index : NSInteger = NSInteger(scrollView.contentOffset.x / kScreenW)
        
        print(index)
    }
}
