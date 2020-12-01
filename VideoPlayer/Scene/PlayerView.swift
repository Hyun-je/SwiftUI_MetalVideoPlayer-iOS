//
//  PlayerView.swift
//  VideoPlayer
//
//  Created by JaehyeonPark on 2020/11/28.
//

import UIKit
import AVKit
import SwiftUI


class PlayerUIView: UIView {
    
    private let playerLayer = AVPlayerLayer()


    override init(frame: CGRect) {
        super.init(frame: frame)
        
        HorizontalStackBlur.register()
        VerticalStackBlur.register()
        

        let player = AVPlayer(url: Bundle.main.url(forResource: "video", withExtension: "mp4")!)
        player.play()

        playerLayer.player = player
        layer.addSublayer(playerLayer)
        
        let currentItem = player.currentItem!
        currentItem.videoComposition = AVVideoComposition(
            asset: currentItem.asset,
            applyingCIFiltersWithHandler: { request in

                let output =
                    request.sourceImage
                    .applyingFilter("HorizontalStackBlur")
                    .applyingFilter("VerticalStackBlur")

                request.finish(with: output, context: nil)
        })
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        playerLayer.frame = bounds
    }
    
}



struct PlayerView: UIViewRepresentable {
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) {

    }

    func makeUIView(context: Context) -> UIView {
        return PlayerUIView(frame: .zero)
    }
}
