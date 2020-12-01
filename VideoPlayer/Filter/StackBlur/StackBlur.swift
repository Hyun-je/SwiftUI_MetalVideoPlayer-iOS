//
//  StackBlur.swift
//  VideoPlayer
//
//  Created by JaehyeonPark on 2020/11/28.
//

import CoreImage



class HorizontalStackBlur: CIFilter, StackBlurAttributes {

    private let kernel = try? CIKernel(functionName: "horizontalStackBlurKernel", fromMetalLibraryData: MetalLib.data)
    
    @objc var inputImage: CIImage?
    @objc var inputRadius: Float = 5
        
    override var outputImage: CIImage? {
        guard let inputImage = inputImage else { abort() }
        
        return kernel?.apply(
            extent: inputImage.extent,
            roiCallback: { $1 },
            arguments: [inputImage, inputRadius]
        )
    }
    
}



class VerticalStackBlur: CIFilter, StackBlurAttributes {
    
    private let kernel = try? CIKernel(functionName: "verticalStackBlurKernel", fromMetalLibraryData: MetalLib.data)
    
    @objc var inputImage: CIImage?
    @objc var inputRadius: Float = 5
    
    override var outputImage: CIImage? {
        guard let inputImage = inputImage else { abort() }
        
        return kernel?.apply(
            extent: inputImage.extent,
            roiCallback: { $1 },
            arguments: [inputImage, inputRadius]
        )
    }
    
}
