//
//  UploadPhotoView.swift
//  PhotoEditor
//

import PhotosUI
import SwiftUI
import UIKit

struct UploadPhotoView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var pickerItem: PhotosPickerItem?
    @State private var image: Image?
    
    let onSelect: (Image) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 0)
            
            VStack(spacing: 30.adaptive()) {
                (
                Text("Photo: ")
                    .font(.poppins(24.adaptive(), weight: .bold))
                    .foregroundColor(.lightYellow) +
                Text("First, you need to upload a photo of yourself or the character you want to place on the photo card for further editing.")
                    .font(.poppins(16.adaptive()))
                    .foregroundColor(.white)
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 8.adaptive())
                
                PhotosPicker(selection: $pickerItem, matching: .images) {
                    Color.black
                        .opacity(0.65)
                        .overlay {
                            if let image {
                                image
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                Image(.addPhoto)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 70.adaptive())
                            }
                        }
                        .clipShape(.rect(cornerRadius: 10.adaptive()))
                        .aspectRatio(1, contentMode: .fit)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10.adaptive(), style: .continuous)
                                .inset(by: 1.adaptive())
                                .stroke(LinearGradient.yellow, lineWidth: 2.adaptive())
                        }
                }
                .padding(.horizontal, 8.adaptive())
                
                VStack(spacing: 15.adaptive()) {
                    BorderedButton(title: "DELETE") {
                        pickerItem = nil
                        image = nil
                    }
                    .disabled(image == nil)
                    .opacity(image == nil ? 0.5 : 1)
                    
                    YellowButton(title: "CONTINUE") {
                        if let image {
                            onSelect(image)
                            dismiss()
                        }
                    }
                    .disabled(image == nil)
                    .opacity(image == nil ? 0.5 : 1)
                }
                
                
            }
            .padding(.horizontal, 72.adaptive())
            .onChange(of: pickerItem) { item in
                guard let item else { return }
                Task {
                    if let loaded = try? await item.loadTransferable(type: Image.self) {
                        image = loaded
                    } else {
                        print("Failed")
                    }
                }
            }
            
            Spacer(minLength: 0)
        }
        .background {
            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0),
                    .init(color: .black.opacity(0.7), location: 0.1)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(edges: .bottom)
        }
        .setDefaultBackground()
        .navigationContent(title: "Uploading photo")
    }
}
