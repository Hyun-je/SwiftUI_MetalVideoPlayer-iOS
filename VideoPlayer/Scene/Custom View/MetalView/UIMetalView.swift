//
//  UIMetalView.swift
//  VideoPlayer
//
//  Created by JaehyeonPark on 2020/11/28.
//

import UIKit
import MetalKit

import Metal
import CoreVideo
import AVFoundation
 

protocol UIMetalViewFilterSource {
    
    func metalView(willRender frame: CIImage) -> CIImage
}



class UIMetalView: MTKView {
   
    private var ciContext       = CIContext?.none
    private var commandQueue    = MTLCommandQueue?.none

    private      let player     = AVPlayer()
    private(set) var videoURL   = URL?.none
    

    lazy var playerItemVideoOutput: AVPlayerItemVideoOutput = {
        let attributes = [kCVPixelBufferPixelFormatTypeKey as String : Int(kCVPixelFormatType_32BGRA)]
        return AVPlayerItemVideoOutput(pixelBufferAttributes: attributes)
    }()
    
    lazy var displayLink: CADisplayLink = {
        let displayLink = CADisplayLink(target: self, selector: #selector(readBuffer))
        displayLink.add(to: .current, forMode: .default)
        displayLink.isPaused = true
        return displayLink
    }()
    
    var filterSource: UIMetalViewFilterSource?

    
    
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
   
    override init(frame frameRect: CGRect, device: MTLDevice?) {
        super.init(frame: frameRect, device: device)
    
        guard let metalDevice = device else { return }

        ciContext = CIContext(mtlDevice: metalDevice)
        commandQueue = metalDevice.makeCommandQueue()

        framebufferOnly = false
        enableSetNeedsDisplay = true

        contentMode = .scaleAspectFit

    }
    
    
    
    
    @objc private func readBuffer(_ sender: CADisplayLink) {

        let nextVSync = sender.timestamp + sender.duration
        let currentTime = playerItemVideoOutput.itemTime(forHostTime: nextVSync)
        
        if playerItemVideoOutput.hasNewPixelBuffer(forItemTime: currentTime) {
            let pixelBuffer = playerItemVideoOutput.copyPixelBuffer(forItemTime: currentTime, itemTimeForDisplay: nil)
            render(pixelBuffer: pixelBuffer)
        }
    }
    
    private func render(pixelBuffer: CVImageBuffer?) {
        
        guard let commandBuffer = commandQueue?.makeCommandBuffer(),
              let pixelBuffer = pixelBuffer,
              let drawable = self.currentDrawable
        else {
            return
        }
        

        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        drawableSize = CGSize(width: width, height: height)
                
        let ciImage = CIImage(cvImageBuffer: pixelBuffer)
        let filteredImage = filterSource?.metalView(willRender: ciImage)

        ciContext?.render(
            filteredImage ?? ciImage,
            to: drawable.texture,
            commandBuffer: commandBuffer,
            bounds: CGRect(origin: .zero, size: drawableSize),
            colorSpace: CGColorSpaceCreateDeviceRGB()
        )

        commandBuffer.present(drawable)
        commandBuffer.commit()
        
        setNeedsDisplay()
    }
   
   

    
    public func loadVideo(url: URL?) {
       
        guard let url = url, videoURL != url
        else { return }
        
        videoURL = url

        let asset = AVURLAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        playerItem.add(playerItemVideoOutput)

        player.replaceCurrentItem(with: playerItem)
        player.play()
        
        displayLink.isPaused = false
    }
   
}
