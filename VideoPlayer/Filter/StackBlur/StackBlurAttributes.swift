//
//  StackBlurAttributes.swift
//  VideoPlayer
//
//  Created by JaehyeonPark on 2020/11/28.
//

import CoreImage



@objc protocol StackBlurAttributes {
    
    @objc var inputImage: CIImage?  { get set }
    @objc var inputRadius: Float    { get set }
    
    var attributes: [String: Any]   { get }
    
    func setValue(_ value: Any?, forKey key: String)
    
}


extension StackBlurAttributes {
    
    var attributes: [String : Any] {
        return [
            "inputImage": [
                kCIAttributeIdentity: 0,
                kCIAttributeClass: "CIImage",
                kCIAttributeType: kCIAttributeTypeImage
            ],
            "inputRadius": [
                kCIAttributeIdentity: 0,
                kCIAttributeClass: "NSNumber",
                kCIAttributeDefault: 0,
                kCIAttributeMin: 0,
                kCIAttributeType: kCIAttributeTypeScalar
            ]
        ]
    }

    func setValue(_ value: Any?, forKey key: String) {
        
        switch key {
            case "inputImage":
                inputImage = value as? CIImage
                
            case "inputRadius":
                inputRadius = (value as? Float) ?? 0
                
            default:
                break
        }
        
    }
    
}
