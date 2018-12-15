//
//  ZJEditVideoViewController.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/13.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import UIKit

class ZJEditVideoViewController: ZJBaseViewController {
    
    var videoURL : URL? {
        didSet{
           
        }
    }

    // 顶部的
    lazy var headerView : ZJEditVideoHeaderView = {
        let headerView = ZJEditVideoHeaderView(frame: CGRect.zero)
        headerView.backgroundColor = kRGBAColor(33, 33, 33, 0.5)
        return headerView
    }()
    
    lazy var footerView : ZJEditVideoFooterView = {
        let footerView = ZJEditVideoFooterView(frame: CGRect.zero)
        footerView.backgroundColor = kRGBAColor(33, 33, 33, 0.5)
        return footerView
    }()
    lazy var editView : ZJEditVideoView = {
        let editView = ZJEditVideoView.init(frame: self.view.bounds)
        editView.videoURL = self.videoURL
        return editView
    }()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
         setUpAllView()
    }
    
    func setUpAllView() {
        view.addSubview(self.editView)
        editView.addSubview(self.headerView)
        editView.addSubview(self.footerView)
        editView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        headerView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.height.equalTo( kisIphoneX ?  Adapt(84) : Adapt(64))
        }
        footerView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(kisIphoneX ? Adapt(80) : Adapt(60))
        }
    }

}
