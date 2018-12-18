//
//  ZJShowFilterView.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/18.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import UIKit

fileprivate let kMainViewHeight : CGFloat = AdaptW(250)
class ZJShowFilterView: ZJBaseView {

    fileprivate lazy var mainView : UIView = {
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kMainViewHeight))
        let blut = UIBlurEffect(style:UIBlurEffect.Style.dark)
        let effView = UIVisualEffectView.init(effect: blut)
        effView.frame = mainView.bounds
        mainView.addSubview(effView)
        
        let circlePath = UIBezierPath.init(roundedRect: mainView.bounds, byRoundingCorners: UIRectCorner(rawValue: UIRectCorner.topLeft.rawValue | UIRectCorner.topRight.rawValue), cornerRadii: CGSize(width: Adapt(20), height: Adapt(20)))
        let layer = CAShapeLayer.init()
        layer.frame = mainView.bounds
        layer.path = circlePath.cgPath
        mainView.layer.mask = layer
        return mainView;
    }()
    
    override func zj_initView(frame: CGRect) {
        
        let bgTap = UITapGestureRecognizer.init(target: self, action: #selector(dissMissFilterView))
        self.addGestureRecognizer(bgTap)
    }
    
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
    
    @objc func dissMissFilterView() {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.mainView.frame = CGRect(x: 0, y: kScreenH, width: kScreenW, height: kMainViewHeight)
        }) { (_) in
            self.isHidden = true
            self.removeFromSuperview()
        }
    }

}
