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
        GalleryImage(imageName: "birthday1"),
        GalleryImage(imageName: "birthday2"),
        GalleryImage(imageName: "birthday3"),
        GalleryImage(imageName: "bbq1"),
        GalleryImage(imageName: "bbq2"),
        GalleryImage(imageName: "wedding1"),
        GalleryImage(imageName: "wedding2"),
        GalleryImage(imageName: "party1"),
        GalleryImage(imageName: "party2"),
        GalleryImage(imageName: "party3"),
        GalleryImage(imageName: "remote"),
        GalleryImage(imageName: "gaming"),
        GalleryImage(imageName: "beach"),
        GalleryImage(imageName: "mountain"),
        GalleryImage(imageName: "skyscraper"),
        GalleryImage(imageName: "new-year"),
        GalleryImage(imageName: "christmas"),
        GalleryImage(imageName: "halloween"),
        GalleryImage(imageName: "concert1"),
        GalleryImage(imageName: "concert2"),
        GalleryImage(imageName: "corporate"),
        GalleryImage(imageName: "dog"),
        GalleryImage(imageName: "cat"),
        GalleryImage(imageName: "horse"),
        GalleryImage(imageName: "london"),
        GalleryImage(imageName: "madrid"),
        GalleryImage(imageName: "new-york"),
        GalleryImage(imageName: "paris"),
        GalleryImage(imageName: "rome"),
        GalleryImage(imageName: "san-francisco"),
        GalleryImage(imageName: "sydney"),
        GalleryImage(imageName: "tokyo"),
        GalleryImage(imageName: "berlin"),
        
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
    let imageName: String
}
