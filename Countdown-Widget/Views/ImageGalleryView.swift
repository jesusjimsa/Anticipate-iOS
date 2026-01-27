//
//  ImageGalleryView.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 27/1/26.
//

import Foundation
import SwiftUI

struct ImageGalleryView: View {
    @Binding var selectedImage: Image?
    @Binding var selectedImageData: Data?
    @Environment(\.dismiss) private var dismiss
    
    // Add your gallery images here
    let galleryImages: [GalleryImage] = [
        GalleryImage(name: "birthday 1", imageName: "birthday1"),
        GalleryImage(name: "birthday 2", imageName: "birthday2"),
        GalleryImage(name: "birthday 3", imageName: "birthday3"),
//        GalleryImage(name: "wedding", imageName: "wedding"),
//        GalleryImage(name: "vacation", imageName: "vacation"),
//        GalleryImage(name: "graduation", imageName: "graduation"),
//        GalleryImage(name: "anniversary", imageName: "anniversary"),
//        GalleryImage(name: "concert", imageName: "concert"),
        // Add more images as needed
    ]
    
    let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 2) {
                    ForEach(galleryImages) { galleryImage in
                        Button(action: {
                            selectImage(galleryImage)
                        }) {
                            Image(galleryImage.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: (UIScreen.main.bounds.width - 4) / 3,
                                       height: (UIScreen.main.bounds.width - 4) / 3)
                                .clipped()
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .navigationTitle("Choose Image")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                            dismiss()
                          }) {
                            Image(systemName: "xmark")
                          }
                }
            }
        }
    }
    
    private func selectImage(_ galleryImage: GalleryImage) {
        if let uiImage = UIImage(named: galleryImage.imageName) {
            let fixedImage = uiImage.fixedOrientation()
            selectedImage = Image(uiImage: fixedImage)
            
            // Process image for storage
            let resizedImage = fixedImage.resizedForWidget(maxWidth: 400)
            if let compressedData = resizedImage.jpegData(compressionQuality: 0.7) {
                selectedImageData = compressedData
            }
        }
        dismiss()
    }
}

struct GalleryImage: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
}
