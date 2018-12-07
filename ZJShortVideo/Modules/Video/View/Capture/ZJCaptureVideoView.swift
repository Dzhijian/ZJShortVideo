//
//  ZJCaptureVideoView.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/2.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import UIKit
import GPUImage

class ZJCaptureVideoView: UIView {

    /// 初始化 videoCamera
    fileprivate lazy var videoCamera : GPUImageVideoCamera = {
        let videoCamera = GPUImageVideoCamera(sessionPreset: AVCaptureSession.Preset.high.rawValue, cameraPosition: .front)
        return videoCamera!
    }()
    
    fileprivate lazy var showView: GPUImageView  = {
        let showView = GPUImageView(frame: self.bounds)
        return showView
    }()
    
    fileprivate var filter: GPUImageFilter = {
        let filter = GPUImageFilter()
        return filter
    }()
    let saturationFilter = GPUImageSaturationFilter() // 饱和
    let bilateralFilter = GPUImageBilateralFilter() // 磨皮
    let brightnessFilter = GPUImageBrightnessFilter() // 美白
    let exposureFilter = GPUImageExposureFilter() // 曝光
    
    var beautifulFilter = GPUImageFilterGroup()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpVideoCamera()
    }
    
    func setUpVideoCamera() {
        
        addSubview(showView)
        configvideoCameraView()
    }
    
    /// 配置 videoCamera
    func configvideoCameraView() {
        videoCamera.outputImageOrientation = .portrait
        videoCamera.addAudioInputsAndOutputs()
        videoCamera.horizontallyMirrorRearFacingCamera = false
        videoCamera.horizontallyMirrorFrontFacingCamera = true

        try? videoCamera.inputCamera.lockForConfiguration()
        // 自动对焦
        if (videoCamera.inputCamera.isFocusModeSupported(.autoFocus)) {
            videoCamera.inputCamera.focusMode = .continuousAutoFocus
        }
        //自动曝光
        if (videoCamera.inputCamera.isExposureModeSupported(.autoExpose)) {
            videoCamera.inputCamera.exposureMode = .continuousAutoExposure
        }
        //自动白平衡
        if (videoCamera.inputCamera.isWhiteBalanceModeSupported(.autoWhiteBalance)) {
            videoCamera.inputCamera.whiteBalanceMode = .continuousAutoWhiteBalance
        }
        ///防止允许声音通过的情况下，避免录制第一帧黑屏闪屏
        videoCamera.addAudioInputsAndOutputs()
        //设置GPUImage的响应链
        videoCamera.addTarget(filter)
        // 将滤镜添加到显示的 View 上
        filter.addTarget(showView)
        videoCamera.inputCamera.unlockForConfiguration()
        // 开始捕获采集视频
        videoCamera.startCapture()
    }
    // 切换摄像头
    func changeDevice() {
        if videoCamera.inputCamera.position == .front {
            videoCamera = GPUImageVideoCamera(sessionPreset: AVCaptureSession.Preset.high.rawValue, cameraPosition: .back)
            configvideoCameraView()
        }else{
            videoCamera = GPUImageVideoCamera(sessionPreset: AVCaptureSession.Preset.high.rawValue, cameraPosition: .front)
            configvideoCameraView()
        }
    }
    
    func stopVideoCamera() {
        videoCamera.stopCapture()
        filter.removeAllTargets()
    }
    
    deinit {
        stopVideoCamera()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
