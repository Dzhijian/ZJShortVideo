//
//  ZJBeautySettingView.swift
//  ZJShortVideo
//
//  Created by 邓志坚 on 2018/12/23.
//  Copyright © 2018 邓志坚. All rights reserved.
//

import UIKit
enum BeautySettingType {
    case BeautySettingTypeBuffing // 磨皮
    case BeautySettingTypeFaceLift // 磨皮
    case BeautySettingTypeBigEye // 磨皮
}

protocol ZJBeautySettingViewDelegate : NSObjectProtocol {
    func zj_beautySettingWithType(type : BeautySettingType, value : Float)
}
class ZJBeautySettingView: ZJBaseView {
    
    weak var delegate : ZJBeautySettingViewDelegate?
    /// 磨皮
    fileprivate lazy var buffingLab : UILabel = {
        let buffingLab = UILabel()
        buffingLab.textColor = kWhiteColor;
        buffingLab.font = kFontSize(value: 16)
        buffingLab.textAlignment = .center
        buffingLab.text = "磨皮"
        return buffingLab;
    }()
    
    fileprivate lazy var buffingSlider : UISlider = {
        let buffingSlider = UISlider()
        buffingSlider.minimumValue = 0
        buffingSlider.maximumValue = 100
        buffingSlider.isContinuous = true
        buffingSlider.minimumTrackTintColor = kOrangeColor
        buffingSlider.maximumTrackTintColor = kRGBAColor(150, 150, 150, 0.7)
        buffingSlider.tag = kBaseTarget + 1
        buffingSlider.value = 50
        buffingSlider.addTarget(self, action: #selector(sliderValueChange(slider:)), for: .valueChanged)
        return buffingSlider
    }()
    fileprivate lazy var buffingValueLab : UILabel = {
        let buffingValueLab = UILabel()
        buffingValueLab.font = kFontSize(value: 14)
        buffingValueLab.textColor = kLightGrayColor
        buffingValueLab.textAlignment = .center
        return buffingValueLab
    }()
    
    /// 瘦脸
    fileprivate lazy var faceLiftLab : UILabel = {
        let faceLiftLab = UILabel()
        faceLiftLab.textColor = kWhiteColor;
        faceLiftLab.textAlignment = .center
        faceLiftLab.font = kFontSize(value: 16)
        faceLiftLab.text = "瘦脸"
        return faceLiftLab;
    }()
    
    fileprivate lazy var faceLiftSlider : UISlider = {
        let faceLiftSlider = UISlider()
        faceLiftSlider.minimumValue = 0
        faceLiftSlider.maximumValue = 100
        faceLiftSlider.isContinuous = true
        faceLiftSlider.minimumTrackTintColor = kOrangeColor
        faceLiftSlider.maximumTrackTintColor = kRGBAColor(150, 150, 150, 0.7)
        faceLiftSlider.tag = kBaseTarget + 2
        faceLiftSlider.value = 50
        faceLiftSlider.addTarget(self, action: #selector(sliderValueChange(slider:)), for: .valueChanged)
        return faceLiftSlider
    }()
    fileprivate lazy var faceLiftValueLab : UILabel = {
        let faceLiftValueLab = UILabel()
        faceLiftValueLab.font = kFontSize(value: 14)
        faceLiftValueLab.textColor = kLightGrayColor
        faceLiftValueLab.textAlignment = .center
        return faceLiftValueLab
    }()
    
    /// 大眼
    fileprivate lazy var bigEyeLab : UILabel = {
        let bigEyeLab = UILabel()
        bigEyeLab.textColor = kWhiteColor;
        bigEyeLab.textAlignment = .center
        bigEyeLab.font = kFontSize(value: 16)
        bigEyeLab.text = "大眼"
        return bigEyeLab;
    }()
    
    fileprivate lazy var bigEyeSlider : UISlider = {
        let bigEyeSlider = UISlider()
        bigEyeSlider.minimumValue = 0
        bigEyeSlider.maximumValue = 100
        bigEyeSlider.isContinuous = true
        bigEyeSlider.minimumTrackTintColor = kOrangeColor
        bigEyeSlider.maximumTrackTintColor = kRGBAColor(150, 150, 150, 0.7)
        bigEyeSlider.tag = kBaseTarget + 3
        bigEyeSlider.value = 50
        bigEyeSlider.addTarget(self, action: #selector(sliderValueChange(slider:)), for: .valueChanged)
        return bigEyeSlider
    }()
    
    fileprivate lazy var bigEyeValueLab : UILabel = {
        let bigEyeValueLab = UILabel()
        bigEyeValueLab.font = kFontSize(value: 14)
        bigEyeValueLab.textColor = kLightGrayColor
        bigEyeValueLab.textAlignment = .center
        return bigEyeValueLab
    }()
    
    override func zj_initView(frame: CGRect) {
        setUpAllView()
        
        buffingValueLab.text    = "\(Int(buffingSlider.value))"
        faceLiftValueLab.text   = "\(Int(faceLiftSlider.value))"
        bigEyeValueLab.text     = "\(Int(bigEyeSlider.value))"
    }
    
    @objc func sliderValueChange(slider : UISlider) {
        switch slider.tag - kBaseTarget {
        case 1:
            self.buffingValueLab.text = "\(Int(slider.value))"
            self.delegate?.zj_beautySettingWithType(type: .BeautySettingTypeBuffing, value: slider.value)
        case 2:
            self.faceLiftValueLab.text = "\(Int(slider.value))"
            
            self.delegate?.zj_beautySettingWithType(type: .BeautySettingTypeFaceLift, value: slider.value)
        case 3:
            self.bigEyeValueLab.text = "\(Int(slider.value))"
            
            self.delegate?.zj_beautySettingWithType(type: .BeautySettingTypeBigEye, value: slider.value)
        default:
            break
        }
    }
    
    func setUpAllView() {
        addSubview(buffingLab)
        addSubview(buffingSlider)
        addSubview(bigEyeLab)
        addSubview(bigEyeSlider)
        addSubview(faceLiftLab)
        addSubview(faceLiftSlider)
        addSubview(buffingValueLab)
        addSubview(faceLiftValueLab)
        addSubview(bigEyeValueLab)
        
        buffingLab.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Adapt(20))
            make.left.equalToSuperview().offset(Adapt(30))
            make.width.equalTo(Adapt(40))
            make.height.equalTo(Adapt(20))
        }
        
        buffingSlider.snp.makeConstraints { (make) in
            make.centerY.equalTo(buffingLab.snp.centerY)
            make.left.equalTo(buffingLab.snp.right).offset(Adapt(15))
            make.right.equalTo(Adapt(-30))
            make.height.equalTo(Adapt(20))
        }
        
        buffingValueLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(buffingSlider.snp.top).offset(Adapt(-4))
            make.centerX.equalTo(buffingSlider.snp.centerX)
        }
        
        faceLiftLab.snp.makeConstraints { (make) in
            make.top.equalTo(buffingLab.snp.bottom).offset(Adapt(30))
            make.centerX.equalTo(buffingLab.snp.centerX)
            make.width.equalTo(Adapt(40))
            make.height.equalTo(Adapt(20))
        }
        
        faceLiftSlider.snp.makeConstraints { (make) in
            make.centerY.equalTo(faceLiftLab.snp.centerY)
            make.left.equalTo(faceLiftLab.snp.right).offset(Adapt(15))
            make.right.equalTo(Adapt(-30))
            make.height.equalTo(Adapt(20))
        }
        
        faceLiftValueLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(faceLiftSlider.snp.top).offset(Adapt(-4))
            make.centerX.equalTo(faceLiftSlider.snp.centerX)
        }
        
        bigEyeLab.snp.makeConstraints { (make) in
            make.top.equalTo(faceLiftLab.snp.bottom).offset(Adapt(30))
            make.centerX.equalTo(faceLiftLab.snp.centerX)
            make.width.equalTo(Adapt(40))
            make.height.equalTo(Adapt(20))
        }
        
        bigEyeSlider.snp.makeConstraints { (make) in
            make.centerY.equalTo(bigEyeLab.snp.centerY)
            make.left.equalTo(bigEyeLab.snp.right).offset(Adapt(15))
            make.right.equalTo(Adapt(-30))
            make.height.equalTo(Adapt(20))
        }
        bigEyeValueLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(bigEyeSlider.snp.top).offset(Adapt(-4))
            make.centerX.equalTo(bigEyeSlider.snp.centerX)
        }
    }

}
