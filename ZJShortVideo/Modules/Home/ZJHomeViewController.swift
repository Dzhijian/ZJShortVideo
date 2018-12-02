//
//  ZJHomeViewController.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/2.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import UIKit

class ZJHomeViewController: ZJBaseViewController {

    lazy var mainCollection : UICollectionView =  {
       let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: (kScreenW-10)/2, height: Adapt(230))
        let mainCollection = UICollectionView.init(frame: self.view.frame, collectionViewLayout: layout)
        mainCollection.backgroundColor = kOrangeColor
        mainCollection.delegate = self
        mainCollection.dataSource = self
        mainCollection.showsHorizontalScrollIndicator = false
        mainCollection.register(ZJHomeListCell.self, forCellWithReuseIdentifier: ZJHomeListCell.identifier())
        return mainCollection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "ZJShortVideo"
        self.view.addSubview(mainCollection)
    }
    
}



extension ZJHomeViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ZJHomeListCell.identifier(), for: indexPath) as! ZJHomeListCell
        cell.contentView.backgroundColor = kRedColor
        return cell
        
    }
    
}
