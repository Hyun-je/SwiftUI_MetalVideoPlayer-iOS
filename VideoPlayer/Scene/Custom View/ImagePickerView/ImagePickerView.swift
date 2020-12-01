//
//  ImagePickerView.swift
//  VideoPlayer
//
//  Created by JaehyeonPark on 2020/11/27.
//


import SwiftUI
import AVFoundation



struct ImagePickerView {

    @Binding var mediaURL: URL?
    @Environment(\.presentationMode) private var presentationMode


    public func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        var parent: ImagePickerView
         
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }

        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            
            parent.mediaURL = info[.mediaURL] as? URL
            parent.presentationMode.wrappedValue.dismiss()
        }

        public func imagePickerControllerDidCancel(_: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }

    }

}



extension ImagePickerView: UIViewControllerRepresentable {
    
    public func makeUIViewController(context: Context) -> UIImagePickerController {
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        picker.mediaTypes = ["public.movie"]
        picker.allowsEditing = false
        picker.videoExportPreset = AVAssetExportPresetPassthrough
        
        return picker
    }
    
    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }

    
}
