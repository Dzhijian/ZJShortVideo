//
//  ZJBaseViewController.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/2.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import UIKit

class ZJBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = kWhiteColor;
        
        
    }
    
    deinit {
        debugPrint(String(describing: type(of:self)) + " deinit")
    }

}
