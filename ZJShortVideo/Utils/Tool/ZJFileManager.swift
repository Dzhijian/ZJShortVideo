
//
//  ZJFileManager.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/18.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import Foundation

class ZJFileManager : NSObject {
    
    /// 删除文件
    class func zj_removeFile(pathStr : String){
        
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
    
    
    //获取合成视频之后的路径  我这里直接将合成后的视频 移动到系统相册
    class func zj_getVideoMargeFilePath() -> String {
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
    
    
    /// 视频合成
    class func zj_videoCompleteAudioVideoSynthesis(urlArr : [URL], outPutURLStr : String, operation: @escaping () -> ()) {
        
        guard urlArr.count > 0 else {
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
                SVProgressHUD.dismiss()
                operation()
            }
        }
    }
    
}
