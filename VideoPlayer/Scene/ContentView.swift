//
//  ContentView.swift
//  VideoPlayer
//
//  Created by JaehyeonPark on 2020/11/27.
//

import SwiftUI



struct ContentView: View {
    
    @State private var showImagePicker = false
    @State private var videoURL = URL?.none
    @State private var blurRadius = 0.0
    
    var body: some View {
        
        VStack {
            
            MetalView(videoURL: $videoURL, blurRadius: $blurRadius)
            .overlay(
                
                HStack(spacing: 20) {
                    Spacer(minLength: 5)
                    Slider(value: $blurRadius, in: 0...80, step: 1)
                    Button(action: { self.showImagePicker.toggle() }) {
                        Image(systemName: "photo.fill.on.rectangle.fill")
                    }
                    Spacer(minLength: 15)
                }
                .padding()
                .background(Color.black.opacity(0.4))
                
                ,alignment: .top
            )
            
        }
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $showImagePicker) {
            ImagePickerView(mediaURL: $videoURL)
        }

    }
}


struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
    
}
