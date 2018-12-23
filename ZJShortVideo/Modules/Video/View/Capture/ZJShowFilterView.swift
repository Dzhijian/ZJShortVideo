//
//  ZJShowFilterView.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/18.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import UIKit
fileprivate let kItemW : CGFloat = (kScreenW - Adapt(60)) / 5
fileprivate let kMainViewHeight : CGFloat = AdaptW(250)
class ZJShowFilterView: ZJBaseView {
    fileprivate lazy var beautyView : ZJBeautySettingView = {
        let beautyView = ZJBeautySettingView()
        beautyView.isHidden = true
        return beautyView
    }()
    fileprivate lazy var mainView : UIView = {
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kMainViewHeight))
        let blut = UIBlurEffect(style:UIBlurEffect.Style.dark)
        let effView = UIVisualEffectView.init(effect: blut)
        effView.frame = mainView.bounds
        mainView.addSubview(effView)
        
        let circlePath = UIBezierPath.init(roundedRect: mainView.bounds, byRoundingCorners: UIRectCorner(rawValue: UIRectCorner.topLeft.rawValue | UIRectCorner.topRight.rawValue), cornerRadii: CGSize(width: Adapt(10), height: Adapt(10)))
        let layer = CAShapeLayer.init()
        layer.frame = mainView.bounds
        layer.path = circlePath.cgPath
        mainView.layer.mask = layer
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(mainViewAction))
        mainView.addGestureRecognizer(tap)
        return mainView;
    }()
    /// 滤镜 CollectionView
    fileprivate lazy var filterCollection : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kItemW, height: kItemW+Adapt(30))
        layout.minimumLineSpacing = Adapt(10)
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: Adapt(10), bottom: 0, right: Adapt(10))
        layout.scrollDirection = .horizontal
        let filterCollection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        filterCollection.backgroundColor = kClearColor
        filterCollection.delegate = self
        filterCollection.dataSource = self
        filterCollection.showsVerticalScrollIndicator = false
        filterCollection.showsHorizontalScrollIndicator = false
        filterCollection.register(ZJFilterViewItemCell.self, forCellWithReuseIdentifier: ZJFilterViewItemCell.identifier())
        return filterCollection
    }()
    fileprivate lazy var centerLine : UIView = {
        let centerLine = UIView()
        centerLine.backgroundColor = kRGBAColor(150, 150, 150)
        return centerLine
    }()
    fileprivate lazy var botLine : UIView = {
        let botLine = UIView()
        botLine.backgroundColor = kRGBAColor(150, 150, 150)
        return botLine
    }()
    fileprivate lazy var filterBtn : UIButton = {
        let filterBtn = UIButton.init()
        filterBtn.setTitle("滤镜", for: .normal)
        filterBtn.setTitleColor(kLightGrayColor, for: .normal)
        filterBtn.titleLabel?.font = kFontSize(value: 15)
        filterBtn.tag = kBaseTarget + 1
        filterBtn.addTarget(self, action: #selector(filterViewBtnAction(sender:)), for: .touchUpInside)
        return filterBtn
    }()
    
    fileprivate lazy var beautyBtn : UIButton = {
        let beautyBtn = UIButton.init()
        beautyBtn.setTitle("美颜", for: .normal)
        beautyBtn.setTitleColor(kLightGrayColor, for: .normal)
        beautyBtn.titleLabel?.font = kFontSize(value: 15)
        beautyBtn.tag = kBaseTarget + 2
        beautyBtn.addTarget(self, action: #selector(filterViewBtnAction(sender:)), for: .touchUpInside)
        return beautyBtn
    }()
    override func zj_initView(frame: CGRect) {
        
        let bgTap = UITapGestureRecognizer.init(target: self, action: #selector(dissMissFilterView))
        self.addGestureRecognizer(bgTap)
        setUpAllView()
    }
    
    func setUpAllView() {
        mainView.addSubview(filterBtn)
        mainView.addSubview(beautyBtn)
        mainView.addSubview(centerLine)
        mainView.addSubview(botLine)
        mainView.addSubview(filterCollection)
        mainView.addSubview(beautyView)
        
        let btnW : CGFloat = (self.frame.size.width - AdaptW(40)) / 2
        
        filterBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(AdaptW(-5))
            make.height.equalTo(AdaptW(40))
            make.width.equalTo(btnW)
            make.left.equalTo(AdaptW(15))
        }
        
        beautyBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(AdaptW(-5))
            make.height.equalTo(AdaptW(40))
            make.width.equalTo(btnW)
            make.right.equalTo(AdaptW(-15))
        }
        
        centerLine.snp.makeConstraints { (make) in
            make.width.equalTo(0.5)
            make.height.equalTo(AdaptW(20))
            make.centerY.equalTo(filterBtn.snp.centerY)
            make.centerX.equalToSuperview()
        }
        
        botLine.snp.makeConstraints { (make) in
            make.top.equalTo(filterBtn.snp.top).offset(AdaptW(-10))
            make.left.right.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        filterCollection.snp.makeConstraints { (make) in
            make.bottom.equalTo(botLine.snp.top).offset(Adapt(-10))
            make.left.right.equalTo(0)
            make.height.equalTo(Adapt(40)+kItemW)
        }
        
        filterBtn.setTitleColor(kWhiteColor, for: .normal)
        filterBtn.titleLabel?.font = kFontBoldSize(value: 16)
        
        beautyView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(botLine.snp.top).offset(Adapt(-10))
            make.top.equalToSuperview().offset(Adapt(10))
        }
    }
    
    /// 显示 View
    func showfilterView() {
        self.isHidden = false
        UIApplication.shared.keyWindow?.addSubview(self)
        self.addSubview(mainView)
        self.mainView.frame = CGRect(x: 0, y: kScreenH, width: kScreenW, height: kMainViewHeight)
        UIView.animate(withDuration: 0.25, animations: {
            self.mainView.frame = CGRect(x: 0, y: kScreenH - kMainViewHeight, width: kScreenW, height: kMainViewHeight)
        }) { (_) in
            
        }
    }
    /// 影藏 View
    @objc func dissMissFilterView() {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.mainView.frame = CGRect(x: 0, y: kScreenH, width: kScreenW, height: kMainViewHeight)
        }) { (_) in
            self.isHidden = true
            self.removeFromSuperview()
        }
    }
    
    @objc  func filterViewBtnAction(sender : UIButton){
        let tag = sender.tag - kBaseTarget
        if tag == 1 {
            print("滤镜")
            filterBtn.setTitleColor(kWhiteColor, for: .normal)
            filterBtn.titleLabel?.font = kFontBoldSize(value: 16)
            beautyBtn.setTitleColor(kLightGrayColor, for: .normal)
            beautyBtn.titleLabel?.font = kFontBoldSize(value: 15)
            filterCollection.isHidden = false
            beautyView.isHidden = true
        }else if tag == 2 {
            print("美颜")
            beautyBtn.setTitleColor(kWhiteColor, for: .normal)
            beautyBtn.titleLabel?.font = kFontBoldSize(value: 16)
            filterBtn.setTitleColor(kLightGrayColor, for: .normal)
            filterBtn.titleLabel?.font = kFontBoldSize(value: 15)
            filterCollection.isHidden = true
            beautyView.isHidden = false
        }
    }

    @objc func mainViewAction() {
        
    }
}


extension ZJShowFilterView : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ZJFilterViewItemCell.identifier(), for: indexPath) as! ZJFilterViewItemCell
        
        
        return cell
    }
}
