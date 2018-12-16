//
//  ZJEditVideoView.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/15.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import UIKit
import AVFoundation
import GPUImage

class ZJEditVideoView: ZJBaseView {
    
    var videoURL : URL? {
        didSet{
            configPlayerInfo()
        }
    }
    
    var mainPlayer : AVPlayer?
    var audioPlayerItem : AVPlayerItem?
    var playerItem : AVPlayerItem?
    var playerLayer : AVPlayerLayer?
    var movieFile : GPUImageMovie?
    
    //(GPUImageOutput & GPUImageInput)?
    // var filter: (GPUImageOutput & GPUImageInput)?
    fileprivate lazy var filter: (GPUImageOutput & GPUImageInput) = {
        /*
         初始化顶点和碎片着色器
         你可以利用SHADER_STRING宏来写你的着色器。
         @param vertexShaderString顶点着色器的源代码使用
         param 片段着色器的源代码片段着色器使用
         */
        let filter = GPUImageFilter(vertexShaderFrom: kGPUImageVertexShaderString, fragmentShaderFrom: kGPUImagePassthroughFragmentShaderString)
        
        return filter!
    }()

    
    fileprivate lazy var filterView : GPUImageView = {
       let filterView = GPUImageView.init(frame: self.bounds)
        filterView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill
        filterView.setInputRotation(kGPUImageFlipHorizonal, at: 0)
        return filterView
    }()
    
    override func zj_initView(frame: CGRect) {
        do {
            if #available(iOS 10.0, *) {
                try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: AVAudioSession.Mode.default, options: .mixWithOthers)
            } else {
                // Fallback on earlier versions
            }
        } catch {
            print("❌错误")
        }
        
    }
    /// 配置 AVPlayer
    func configPlayerInfo() {

        guard videoURL != nil else {
            print(" ❌ 错误: VideoURL 地址为空")
            return
        }
        mainPlayer = AVPlayer.init()
        playerItem = AVPlayerItem.init(url: videoURL!)
        mainPlayer?.replaceCurrentItem(with: playerItem)
        playerLayer = AVPlayerLayer.init(player: mainPlayer)
        playerLayer?.frame = self.bounds
        
//        self.layer.addSublayer(playerLayer!)
        movieFile = GPUImageMovie.init(playerItem: playerItem)
        movieFile?.runBenchmark = true
        movieFile?.playAtActualSpeed = true
        
        movieFile?.addTarget(filter)
        addSubview(filterView)
        filter.addTarget(filterView)
        
        // 开始播放
        mainPlayer?.play()
        movieFile?.startProcessing()
        
    }

}
