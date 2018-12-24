//
//  ZJCaptureVideoView.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/2.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import UIKit


fileprivate let kTimeInterval : Float = 0.05

protocol ZJCaptureVideoViewDelegate : NSObjectProtocol{
    
    func zj_captureViewVideoCompleteAction(videoURL: URL?)
}

class ZJCaptureVideoView : UIView {
    
    weak var delegate : ZJCaptureVideoViewDelegate?
    weak var viewController : UIViewController?
    
    // 滤镜 View
    lazy var filterView : ZJCaptureFilterView = {
        let filterView = ZJCaptureFilterView(frame: self.bounds)
        filterView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(showViewAction(tap:)))
        filterView.addGestureRecognizer(tap)
        return filterView;
    }()
    
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
    /// 视频显示的 View ,GPUImage输出的端点
    fileprivate lazy var showView: GPUImageView  = {
        let showView = GPUImageView(frame: self.bounds)
        
        return showView
    }()
    /// 进度条
    fileprivate lazy var progressView : ZJVideoProgressView = {
        let progressView = ZJVideoProgressView.init()
        return progressView;
    }()

    /// 聚焦
    lazy var focusLayer : CALayer = CALayer()
    
    /// 保存滤镜处理过的视频
    fileprivate var videoWriter : GPUImageMovieWriter?
    /// 滤镜
    lazy var beautifulFilter : GPUImageFilterGroup = {
        let beautifulFilter = GPUImageFilterGroup()
        return beautifulFilter
    }()
    let saturationFilter    = GPUImageSaturationFilter() // 饱和
    let bilateralFilter     = GPUImageBilateralFilter() // 磨皮
    let brightnessFilter    = GPUImageBrightnessFilter() // 美白
    let exposureFilter      = GPUImageExposureFilter() // 曝光
    
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
    /// 当前总进度
    var progressValue : Float = 0
    /// 新增加的进度
    var progressNewValue : Float = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpVideoCamera()
        /// 配置 videoCamera
        configvideoCameraView()
        
    }
    
    func setUpVideoCamera() {
        addSubview(showView)
        addSubview(filterView)
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
        
        // 自动曝光
        if (videoCamera.inputCamera.isExposureModeSupported(.autoExpose)) {
            videoCamera.inputCamera.exposureMode = .continuousAutoExposure
        }
        
        // 自动白平衡
        if (videoCamera.inputCamera.isWhiteBalanceModeSupported(.autoWhiteBalance)) {
            videoCamera.inputCamera.whiteBalanceMode = .continuousAutoWhiteBalance
        }
        
        // 防止允许声音通过的情况下，避免录制第一帧黑屏闪屏
        videoCamera.addAudioInputsAndOutputs()
        // 配置滤镜
        beautifulFilter = getGroupFilters()
        // 设置GPUImage的响应链
        videoCamera.addTarget(beautifulFilter)
        // 将滤镜添加到显示的 View 上
        beautifulFilter.addTarget(showView)
        videoCamera.inputCamera.unlockForConfiguration()
        // 开始捕获采集视频
        videoCamera.startCapture()
    }
    
    /// 组合滤镜
    fileprivate func getGroupFilters() -> GPUImageFilterGroup {
        //创建滤镜组
        let filterGroup = GPUImageFilterGroup()
        //创建滤镜(设置滤镜的引来关系), 对应添加
        bilateralFilter.addTarget(brightnessFilter)
        brightnessFilter.addTarget(exposureFilter)
        exposureFilter.addTarget(saturationFilter)
        //设置默认值
        // 中心色与样品色之间距离的归一化系数。
        bilateralFilter.distanceNormalizationFactor = 6
        // 曝光范围从-10.0到10.0, 0.0为正常水平
        exposureFilter.exposure = 0
        // 亮度范围从-1.0到1.0，正常亮度为0.0
        brightnessFilter.brightness = 0
        // 饱和度范围从0.0(完全饱和)到2.0(最大饱和度)，1.0为正常水平
        saturationFilter.saturation = 1.0
        //设置滤镜起点 终点的filter
        filterGroup.initialFilters = [bilateralFilter]
        filterGroup.terminalFilter = saturationFilter
        return filterGroup
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
        beautifulFilter.removeAllTargets()
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
        // 计算总的时间
        self.kCurrentTime =  self.kCurrentTime + kTimeInterval
        // 计算新增加的时间值
        self.progressNewValue = self.progressNewValue + kTimeInterval
        self.progressValue = progress
        //设置进度条进度
        self.progressView.zj_setProgress(value: progress)
        
    }
    /// 暂停定时器
    func stopTimer()  {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    /// 完成录制
    func finishCaptureVideo() {
        SVProgressHUD.show(withStatus: "视频合成中...")
        videoCamera.audioEncodingTarget = nil
        let outputPathStr : String = ZJFileManager.zj_getVideoMargeFilePath()
        self.zj_videoCompleteAudioVideoMerge(urlArr: pathArray, outPutURLStr: outputPathStr)
    }
    
    deinit {
        stopVideoCamera()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - 音视频处理
extension ZJCaptureVideoView {
    /// 音视频合并
    fileprivate func zj_videoCompleteAudioVideoMerge(urlArr : [URL], outPutURLStr : String) {
        
        ZJFileManager.zj_videoCompleteAudioVideoSynthesis(urlArr: urlArr, outPutURLStr: outPutURLStr) {
            self.videoCamera.stopCapture()
            self.delegate?.zj_captureViewVideoCompleteAction(videoURL: URL(fileURLWithPath: outPutURLStr))
        }
        
        guard self.pathArray.count > 0 else {
            SVProgressHUD.dismiss()
            SVProgressHUD.showError(withStatus: "暂未录制视频")
            return
        }
    }
    
    @objc func showViewAction(tap : UITapGestureRecognizer) {
        let centerPoint = tap.location(in: showView)
        self .setFocusLayer()
        // 焦点动画
        self.focusLayerAnimation(point: centerPoint)
        let device : AVCaptureDevice = videoCamera.inputCamera
        // 获取相机坐标点
        let pointOfInterest = convertToPointOfInterestFromViewCoordinates(view: showView, viewCoordinates: centerPoint)
        
        do {
            if try device.lockForConfiguration() != nil {
            
            if device.isFocusPointOfInterestSupported && device.isFocusModeSupported(.continuousAutoFocus) {
                device.focusPointOfInterest = pointOfInterest
                device.focusMode = .continuousAutoFocus
            }
            
            if device.isExposurePointOfInterestSupported && device.isExposureModeSupported(.continuousAutoExposure) {
                device.exposurePointOfInterest = pointOfInterest
                device.exposureMode = .continuousAutoExposure
            }
            
            device.unlockForConfiguration()
            
            print("FOCUS OK")
            }
            
        } catch {
            print("FOCUS")
        }

    }
    
    
    
    fileprivate func setFocusLayer() {
        guard focusLayer.isHidden else {
            return
        }
        let focusImage = UIImage(named: "focusing_button_65x65_")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: focusImage?.size.width ?? 0.0, height: focusImage?.size.height ?? 0.0))
        imageView.image = focusImage
        let layer: CALayer = imageView.layer
        layer.isHidden = true
        filterView.layer.addSublayer(layer)
        focusLayer = layer
    }
    
    fileprivate func focusLayerAnimation(point : CGPoint) {
       
        focusLayer.isHidden = false
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        focusLayer.position = point
        focusLayer.transform = CATransform3DMakeScale(2.0, 2.0, 1.0)
        CATransaction.commit()
        
        
        let animation = CABasicAnimation(keyPath: "transform")
        animation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0))
        animation.duration = 0.3
        animation.repeatCount = 1
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        focusLayer.add(animation, forKey: "animation")
        
        // 0.5秒钟延时
        perform(#selector(focusLayerNormalStatu), with: self, afterDelay: 0.5)
    }
    
    @objc func focusLayerNormalStatu() {
        showView.isUserInteractionEnabled = true
        focusLayer.isHidden = true
    }
    
    func zj_changeFilter(filterModel : ZJFilterModel) {
        // 移除旧的滤镜
        beautifulFilter.removeAllTargets()
        // 配置滤镜
        beautifulFilter = filterModel.filter!
        // 设置GPUImage的响应链
        videoCamera.addTarget(beautifulFilter)
        // 将滤镜添加到显示的 View 上
        beautifulFilter.addTarget(showView)
        
    }
    
    
}

extension ZJCaptureVideoView : ZJCaptureBotViewDeleagte{
    /// 开始捕获视频
    func zj_captureBtnStartAction(sender: UIButton?) {
        print("开始捕获视频")
        
        
        captureBotView.captureToolBtnIsHidden(isHidden: true)
        self.videoPath = NSHomeDirectory() + "/tmp/movie\(pathArray.count).mp4"
        print(videoPath! + "\(self.videoPath ?? "videoPath 错误")")
        //如果一个文件已经存在，AVAssetWriter不会让你记录新的帧
        unlink(self.videoPath)

        // 视频文件路径
        let videoURL : URL = URL.init(fileURLWithPath: self.videoPath!)
        
        print(videoURL)
        self.videoWriter = GPUImageMovieWriter.init(movieURL: videoURL, size: CGSize(width: 720.0, height: 1280.0))
        videoWriter!.hasAudioTrack = true
        videoWriter!.encodingLiveVideo = true
        videoWriter!.shouldPassthroughAudio = true
        
        beautifulFilter.addTarget(videoWriter)
        videoCamera.audioEncodingTarget = videoWriter
        videoWriter!.startRecording()
        self.isRecording = true
        self.startTimer()
    }
    
    /// 暂停捕获视频
    func zj_captureBtnStopAction(sender: UIButton?) {
        print("暂停捕获视频")
        self.stopTimer()
        captureBotView.captureToolBtnIsHidden(isHidden: false)
        videoCamera.audioEncodingTarget = nil
        print("videoPath:" + "\(String(describing: self.videoPath))")
        if self.isRecording {
            videoWriter!.finishRecording()
            beautifulFilter.removeTarget(videoWriter)
            let urlStr : String = self.videoPath ?? ""
            self.pathArray.append(URL(fileURLWithPath: urlStr))
            
            // 添加进度条的分割线
            self.progressView.zj_addlineLayer(value: self.progressValue, newValue: self.progressNewValue / self.kTotalTime)
            // 重置新增加的时间
            self.progressNewValue = 0;
            self.isRecording = false
        }
        
    }
    /// 删除视频片段
    func zj_captureDeleteBtnAction(sender: UIButton?) {
        let alert = UIAlertController.init(title: "您确定要删除上一段视频?", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let confirm = UIAlertAction.init(title: "删除", style: .default) { (_) in
            guard self.pathArray.count == 0 else {
                ZJFileManager.zj_removeFile(pathStr: (self.pathArray.last?.absoluteString)!)
                self.pathArray.removeLast()
                self.progressView.zj_deleteLineAndValue()
                return
            }
        }
        alert.addAction(cancel)
        alert.addAction(confirm)
        self.viewController?.present(alert, animated: true, completion: nil)
        
    }
    /// 完成视频录制
    func zj_captureCompleteBtnAction(sender: UIButton?) {
        self.finishCaptureVideo()
    }

}
