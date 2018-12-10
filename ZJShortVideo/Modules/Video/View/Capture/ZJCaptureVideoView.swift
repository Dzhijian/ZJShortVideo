//
//  ZJCaptureVideoView.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/2.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import UIKit
import GPUImage

fileprivate let kTimeInterval : Float = 0.05

class ZJCaptureVideoView: UIView {

    /// 初始化 videoCamera
    fileprivate lazy var videoCamera : GPUImageVideoCamera = {
        let videoCamera = GPUImageVideoCamera(sessionPreset: AVCaptureSession.Preset.high.rawValue, cameraPosition: .front)
        
        return videoCamera!
    }()
    /// 捕获按钮
    lazy var captureBotView : ZJCaptureBotView = {
        let captureBotView = ZJCaptureBotView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: AdaptW(100)))
        captureBotView.delegate = self;
        return captureBotView
    }()
    
    fileprivate lazy var showView: GPUImageView  = {
        let showView = GPUImageView(frame: self.bounds)
        return showView
    }()
    fileprivate lazy var progressView : UIProgressView = {
        let progressView = UIProgressView.init()
        progressView.trackTintColor = kRGBAColor(100, 100, 100, 0.5)
        progressView.progressTintColor = kOrangeColor
        progressView.layer.cornerRadius = Adapt(4)
        progressView.layer.masksToBounds = true
        return progressView;
    }()
    
    fileprivate var filter: GPUImageFilter = {
        let filter = GPUImageFilter()
        return filter
    }()
    
    fileprivate var videoWriter : GPUImageMovieWriter?
    
    let saturationFilter    = GPUImageSaturationFilter() // 饱和
    let bilateralFilter     = GPUImageBilateralFilter() // 磨皮
    let brightnessFilter    = GPUImageBrightnessFilter() // 美白
    let exposureFilter      = GPUImageExposureFilter() // 曝光
    var beautifulFilter     = GPUImageFilterGroup()
    /// 视频总时间长度
    var kTotalTime : Float = 15
    /// 上次记录的时间
    var kLastTime : Float = 0
    /// 当前录制的时间
    var kCurrentTime : Float = 0
    /// 是否正在录制
    var isRecording : Bool = false
    /// 视频保存路径
    var videoPath : String?
    /// 定时器
    var timer : Timer?
    /// 保存视频路径
    var pathArray : [URL] = [URL]()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpVideoCamera()
        /// 配置 videoCamera
        configvideoCameraView()
        
    }
    
    func setUpVideoCamera() {
        addSubview(showView)
        addSubview(progressView)
        addSubview(captureBotView)
        progressView.snp.makeConstraints { (make) in
            make.top.equalTo(Adapt(10));
            make.left.equalTo(Adapt(10));
            make.right.equalTo(Adapt(-10));
            make.height.equalTo(Adapt(8));
        }
        
        captureBotView.snp.makeConstraints { (make) in
            make.bottom.equalTo(Adapt(-30))
            make.width.equalTo(kScreenW)
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(AdaptW(100))
        }
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
    
    /// 开启定时器
    func startTimer() {
        // 每0.05秒执行一次
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(kTimeInterval), target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    /// 定时器任务
    @objc func timerAction() {
        
        let progress : Float = self.kCurrentTime / self.kTotalTime;
        if progress >= 1 {
            self.stopTimer()
            self.captureBotView.stopRecordVideo(sender: nil)
        }
        self.kCurrentTime =  self.kCurrentTime + kTimeInterval
        self.progressView.progress = progress
        print("progress" + "\(progress)/")
        
    }
    /// 暂停定时器
    func stopTimer()  {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    deinit {
        stopVideoCamera()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ZJCaptureVideoView : ZJCaptureBotViewDeleagte{
    /// 开始捕获视频
    func zj_captureBtnStartAction(sender: UIButton?) {
        print("开始捕获视频")
        self.videoPath = NSTemporaryDirectory() + "Movie" + "\(pathArray.count)" + ".mov"
        print(videoPath! + "\(self.videoPath ?? "videoPath 错误")")
        //如果一个文件已经存在，AVAssetWriter不会让你记录新的帧，所以删除旧的电影
        unlink(self.videoPath)
        // 视频文件路径
        let videoURL : URL = URL.init(fileURLWithPath: self.videoPath!)
        
        print(videoURL)
        self.videoWriter = GPUImageMovieWriter.init(movieURL: videoURL, size: CGSize(width: 720.0, height: 1280.0))
        videoWriter!.hasAudioTrack = true
        videoWriter!.encodingLiveVideo = true
        videoWriter!.shouldPassthroughAudio = true
        
        self.filter.addTarget(videoWriter)
        videoCamera.audioEncodingTarget = videoWriter
        videoWriter!.startRecording()
        self.isRecording = true
        self.startTimer()
    }
    
    /// 暂停捕获视频
    func zj_captureBtnStopAction(sender: UIButton?) {
        print("暂停捕获视频")
        self.stopTimer()
        videoCamera.audioEncodingTarget = nil
        print("videoPath:" + "\(String(describing: self.videoPath))")
        if self.isRecording {
            videoWriter!.finishRecording()
            filter.removeTarget(videoWriter)
            let urlStr : String = "file://" + "\(self.videoPath ?? "")"
            // 保存当前视频路径
            self.pathArray.append(URL(string: urlStr)!)
            self.isRecording = false
        }
        
    }
    
    
    
}
