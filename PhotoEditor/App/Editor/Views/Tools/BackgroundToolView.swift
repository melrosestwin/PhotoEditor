//
//  BackgroundToolView.swift
//  PhotoEditor
//

import SwiftUI
import PhotosUI

enum BackgroundTab: CaseIterable {
    case color
    case image
    case generated
    
    var title: String {
        switch self {
        case .color: "Color"
        case .image: "Image"
        case .generated: "Image generation"
        }
    }
}

enum BackgroundType: Equatable {
    
    case color(Color)
    case image(UIImage)
}

enum BackgroundColor: Int, CaseIterable {
    case white
    case red
    case darkBlue
    case yellow
    case lightBlue
    case green
    case pink
    case orange
    
    var color: Color {
        switch self {
        case .white: .white
        case .red: .red
        case .darkBlue: .darkBlue
        case .yellow: .darkYellow
        case .lightBlue: .lightBlue
        case .green: .brandGreen
        case .pink: .brandPink
        case .orange: .brandBrown
        }
    }
    
    static let topCases: [BackgroundColor] = [.white, .red, .darkBlue, .yellow]
    static let bottomCases: [BackgroundColor] = [.lightBlue, .green, .pink, .orange]
}

struct BackgroundToolView: View {
    
    @State private var pickerItem: PhotosPickerItem?
    
    @State private var userImages: [UIImage] = []
    private let templateImages: [UIImage] = SportKind.soccer.backgrounds.map({ UIImage(resource: $0) })
    private let templateColors: [[Color]] = [
        [.white, .red, .darkBlue, .yellow],
        [.lightBlue, .green, .pink, .orange]
    ]
    
    
    @State var selectedType: BackgroundTab = .image
    @State var selectedBackground: BackgroundType?
    
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Button {
                    
                } label: {
                    Image(.crossButton)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 34.adaptive(), height: 34.adaptive())
                }
                
                Spacer()
                
                ForEach(BackgroundTab.allCases, id: \.self) { type in
                    Text(type.title)
                        .font(.poppins(13.adaptive()))
                        .foregroundStyle(selectedType == type ? .lightYellow : .white)
                        .contentShape(.rect)
                        .onTapGesture {
                            selectedType = type
                        }
                
                    Spacer()
                }
                
                Button {
                    
                } label: {
                    Image(.checkButton)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 34.adaptive(), height: 34.adaptive())
                }
            }
            .padding(.horizontal, 16.adaptive())
            
            switch selectedType {
            case .color:
                colorsView
                    .frame(height: 104.adaptive())
            case .image:
                imagesView
                    .frame(height: 104.adaptive())
            case .generated:
                Spacer()
            }
        }
    }
    
    var colorsView: some View {
        HStack(spacing: 20.adaptive()) {
            Button {
                selectedBackground = nil
            } label: {
                RoundedRectangle(cornerRadius: 10.adaptive(), style: .continuous)
                    .fill(.white.opacity(0.28))
                    .frame(width: 68.adaptive())
                    .overlay {
                        Image(systemName: "trash")
                            .resizable()
                            .scaledToFit()
                            .tint(.white)
                            .frame(width: 27.adaptive(), height: 27.adaptive())
                    }
            }

            VStack(spacing: 16.adaptive()) {
                ForEach(templateColors, id: \.self) { line in
                    HStack(spacing: 20.adaptive()) {
                        ForEach(line, id: \.self) { color in
                            Circle()
                                .fill(color)
                                .overlay {
                                    if selectedBackground == .color(color) {
                                        Circle()
                                            .inset(by: 3.5)
                                            .stroke(.black.opacity(0.5), lineWidth: 7)
                                    }
                                }
                                .onTapGesture {
                                    selectedBackground = .color(color)
                                }
                        }
                    }
                }
            }
            .padding(.vertical, 6.adaptive())
        }
    }
    
    var imagesView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20.adaptive()) {
                
                PhotosPicker(selection: $pickerItem, matching: .images) {
                    RoundedRectangle(cornerRadius: 10.adaptive(), style: .continuous)
                        .fill(.white.opacity(0.28))
                        .frame(width: 68.adaptive())
                        .overlay {
                            Image(.addPhoto)
                                .resizable()
                                .scaledToFit()
                                .tint(.white)
                                .frame(width: 34.adaptive(), height: 34.adaptive())
                        }
                }
                .onChange(of: pickerItem) { item in
                    guard let item else { return }
                    Task {
                        if let data = try? await item.loadTransferable(type: Data.self),
                           let image = UIImage(data: data) {
                            userImages.append(image)
                        } else {
                            print("Failed")
                        }
                    }
                }

                ForEach(userImages + templateImages, id: \.self) { uiImage in
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                        .clipShape(.rect(cornerRadius: 10.adaptive(), style: .continuous))
                        .overlay {
                            if selectedBackground == .image(uiImage) {
                                RoundedRectangle(cornerRadius: 10.adaptive(), style: .continuous)
                                    .inset(by: 1)
                                    .stroke(.lightYellow, lineWidth: 2)
                            }
                        }
                        .onTapGesture {
                            selectedBackground = .image(uiImage)
                        }
                }
            }
            .padding(.horizontal, 16.adaptive())
        }
    }
}

#Preview {
    BackgroundToolView()
}
