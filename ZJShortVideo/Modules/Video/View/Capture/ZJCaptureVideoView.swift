//
//  ZJCaptureVideoView.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/2.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import UIKit
import GPUImage
import SVProgressHUD

fileprivate let kTimeInterval : Float = 0.05

protocol ZJCaptureVideoViewDelegate : NSObjectProtocol{
    
    func zj_captureViewVideoCompleteAction(videoURL: URL?)
}

class ZJCaptureVideoView : UIView {
    
    weak var delegate : ZJCaptureVideoViewDelegate?
    
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
        // 配置滤镜
        beautifulFilter = getGroupFilters()
        //设置GPUImage的响应链
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
        bilateralFilter.distanceNormalizationFactor = 5.5
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
        let outputPathStr : String = self.getVideoMargeFilePath()
        self.zj_videoCompleteAudioVideoSynthesis(urlArr: pathArray, outPutURLStr: outputPathStr)
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
    /// 音视频合成
    func zj_videoCompleteAudioVideoSynthesis(urlArr : [URL], outPutURLStr : String) {
        
        guard self.pathArray.count > 0 else {
            SVProgressHUD.dismiss()
            SVProgressHUD.showError(withStatus: "暂未录制视频")
            return
        }
        
        // 创建音视频合成对象
        let composition = AVMutableComposition()
        // 创建音视通道容器
        let audioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        // 创建视频通道容器
        let videoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        // 视频时间
        var totalDuration = CMTime.zero
        
        // 遍历合成所有音视频
        for (index,item) in urlArr.enumerated() {
            
            print("第" + "\(index)" + "段 : " + "\(item)")
            do{
                let options = [AVURLAssetPreferPreciseDurationAndTimingKey : true]
                let asset = AVURLAsset.init(url: item, options: options)
                
                //获取AVAsset中的音频
                let assetAudioTrack = asset.tracks(withMediaType: AVMediaType.audio).first
                // 向通道内加入音频
                try audioTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: asset.duration), of: assetAudioTrack!, at: totalDuration)
                
                //获取AVAsset中的视频
                let assetVideoTrack = asset.tracks(withMediaType: AVMediaType.video).first
                // 向通道内加入视频
                try videoTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: asset.duration), of: assetVideoTrack!, at: totalDuration)
                
                totalDuration = CMTimeAdd(totalDuration, asset.duration);
            } catch {
                print("第" + "\(index)" + "段音视频插入失败")
            }
        }
        
        
        // 音视频合成导出
        let exprotSession : AVAssetExportSession = AVAssetExportSession.init(asset: composition, presetName: AVAssetExportPresetHighestQuality)!
        // 输出地址
        let saveUrl = URL.init(fileURLWithPath: outPutURLStr)
        exprotSession.outputURL = saveUrl
        // 输出类型
        exprotSession.outputFileType = AVFileType.mp4
        exprotSession.shouldOptimizeForNetworkUse = true
        // 合成完毕
        exprotSession.exportAsynchronously {
        
            // 返回主线程继续操作
            DispatchQueue.main.async {
                self.videoCamera.stopCapture()
                SVProgressHUD.dismiss()
                self.delegate?.zj_captureViewVideoCompleteAction(videoURL: URL(fileURLWithPath: outPutURLStr))
            }
        }
        
        
    }
    
   
    
    //获取合成视频之后的路径  我这里直接将合成后的视频 移动到系统相册
    func getVideoMargeFilePath() -> String {
        let tempath = NSTemporaryDirectory() + "/videoFolder"
        if FileManager.default.fileExists(atPath: tempath) == false {
            try! FileManager.default.createDirectory(atPath: tempath, withIntermediateDirectories: true, attributes: nil)
        }
        let dataFormatter =  DateFormatter()
        dataFormatter.dateFormat = "yyyyMMddHHmmss"
        let nowstr = dataFormatter.string(from: Date())
        let pth = tempath + "/\(nowstr)" + "merge.mp4"
        return pth
    }
}

extension ZJCaptureVideoView : ZJCaptureBotViewDeleagte{
    /// 开始捕获视频
    func zj_captureBtnStartAction(sender: UIButton?) {
        print("开始捕获视频")
        
        
        captureBotView.captureToolBtnIsHidden(isHidden: true)
        self.videoPath = NSHomeDirectory() + "/tmp/movie\(pathArray.count).mov" //NSTemporaryDirectory() + "movie" + "\(pathArray.count)" + ".mov"
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
//        self.filter = bilateralFilter
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
        
        guard self.pathArray.count == 0 else {
            self.removeFile(pathStr: (self.pathArray.last?.absoluteString)!)
            self.pathArray.removeLast()
            self.progressView.zj_deleteLineAndValue()
            return
        }
        
    }
    /// 完成视频录制
    func zj_captureCompleteBtnAction(sender: UIButton?) {
        self.finishCaptureVideo()
    }
    
    
    /// 删除文件
    func removeFile(pathStr : String){
        
        //获得文件管理对象
        let fileManger = FileManager.default
        // 创建一个字符串对象，表示文档目录下的一个图片
        let sourceUrl = pathStr.replacingOccurrences(of: "file://", with: "")
        print("需要删除文件的路径" + sourceUrl)
        
        do{
            print("Success to remove file.")
            try fileManger.removeItem(atPath: sourceUrl)
        }catch{
            print("Failed!")
        }
    }
    
}
