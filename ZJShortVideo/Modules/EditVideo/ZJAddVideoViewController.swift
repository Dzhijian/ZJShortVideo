//
//  ZJAddVideoViewController.swift
//  ZJShortVideo
//#imageLiteral(resourceName: "appicon.png")
//  Created by 邓志坚 on 2018/12/2.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import AssetsLibrary

class ZJAddVideoViewController: ZJBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.perform(#selector(presenVC), with: 0.5)
        
    }
    
    @objc func presenVC() {

        self.present(ZJCaptureVideoViewController(), animated: true, completion: nil)
    }
    
}
