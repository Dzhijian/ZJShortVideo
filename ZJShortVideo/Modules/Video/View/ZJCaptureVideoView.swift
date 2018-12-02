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

    lazy var videoCamera: GPUImageVideoCamera = {
        let videoCamera = GPUImageVideoCamera(sessionPreset: AVCaptureSession.Preset.hd1280x720.rawValue, cameraPosition: .front)

        
        videoCamera?.outputImageOrientation = .portrait
        videoCamera?.addAudioInputsAndOutputs()
        videoCamera?.horizontallyMirrorRearFacingCamera = false
        videoCamera?.horizontallyMirrorFrontFacingCamera = true
        return videoCamera!
    }()
    var filter: GPUImageFilter?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpVideoCamera()
    }
    
    func setUpVideoCamera() {
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
        videoCamera.inputCamera.unlockForConfiguration()
        videoCamera.startCapture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
