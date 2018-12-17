
//
//  ZJFileManager.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/18.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import Foundation


/// 删除文件
func zj_removeFile(pathStr : String){
    
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
func zj_getVideoMargeFilePath() -> String {
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
