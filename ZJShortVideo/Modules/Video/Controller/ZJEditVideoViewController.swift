//
//  ZJEditVideoViewController.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/13.
//  Copyright © 2018 邓志坚. All rights reserved.
//  

import UIKit
import SVProgressHUD

class ZJEditVideoViewController: ZJBaseViewController {
    
    var videoURL : URL?

    // 顶部的
    lazy var headerView : ZJEditVideoHeaderView = {
        let headerView = ZJEditVideoHeaderView(frame: CGRect.zero)
        headerView.backgroundColor = kRGBAColor(33, 33, 33, 0.5)
        headerView.delegate = self
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



// MARK: - ZJEditVideoHeaderViewDelegate
extension ZJEditVideoViewController : ZJEditVideoHeaderViewDelegate {
    
    func zj_headerToolBtnAction(actionType: HeaderViewBtnActionType) {
        if actionType == .HeaderViewBtnActionTypeCancel {
            self.navigationController?.popViewController(animated: true)
        }else{
            let pathStr : String = self.videoURL?.relativeString ?? ""
            let saveUrl  = pathStr.replacingOccurrences(of: "file://", with: "")
            
            let alertView = UIAlertController.init(title: "您确定要添加此视频到相册吗?", message: "", preferredStyle: .alert)
            let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
            let confirm = UIAlertAction.init(title: "确定", style: .default) { (_) in
                SVProgressHUD.show(withStatus: "正在保存...")
                //将视频保存到相册
                if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(saveUrl)) {
                    UISaveVideoAtPathToSavedPhotosAlbum(saveUrl, self, #selector(self.didFinishSavingWithError(path:error:contextInfo:)), nil);
                }
            }
            
            alertView.addAction(cancel)
            alertView.addAction(confirm)
            self.present(alertView, animated: true, completion: nil)
        }
    }
    
    @objc func didFinishSavingWithError (path pth:String ,error:Error?,contextInfo:Any?) {
        print(pth)
        if error == nil {
            print("保存视频到本地成功")
            SVProgressHUD.dismiss(withDelay: 0.5) {
                SVProgressHUD.showSuccess(withStatus: "保存成功")
            }
        }else{
            print("保存视频到本地失败")
        }
    }

}
