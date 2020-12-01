//
//  MetalView.swift
//  VideoPlayer
//
//  Created by JaehyeonPark on 2020/11/28.
//

import SwiftUI



struct MetalView {
    
    @Binding var videoURL: URL?
    @Binding var blurRadius: Double
    
    
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, UIMetalViewFilterSource {

        var parent: MetalView
         
        init(_ parent: MetalView) {
            self.parent = parent
            
            CIFilter.registerName(
                String(describing: HorizontalStackBlur.self),
                constructor: FilterConstructor<HorizontalStackBlur>(),
                classAttributes: [:]
            )
            CIFilter.registerName(
                String(describing: VerticalStackBlur.self),
                constructor: FilterConstructor<VerticalStackBlur>(),
                classAttributes: [:]
            )
        }

        func metalView(willRender frame: CIImage) -> CIImage {
            
            let patameters = ["inputRadius": Float(parent.blurRadius)]

            return frame
                .applyingFilter("HorizontalStackBlur", parameters: patameters)
                .applyingFilter("VerticalStackBlur", parameters: patameters)
            
        }

    }
    
}



extension MetalView: UIViewRepresentable {

    func makeUIView(context: Context) -> UIView {
        
        let metalView = UIMetalView(frame: .zero, device: MTLCreateSystemDefaultDevice())
        metalView.filterSource = context.coordinator
        
        return metalView
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<MetalView>) {
        
        guard let metalView = uiView as? UIMetalView else { return }
        metalView.loadVideo(url: videoURL)
        
    }

}
