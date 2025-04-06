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
    case prompt(String)
    case clear
}

struct BackgroundToolView<GenerativeContent: View>: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var importedImages: FetchedResults<StoredImage>
    
    @State private var pickerItem: PhotosPickerItem?
    
    private var userImages: [UIImage] {
        return importedImages.compactMap(\.uiImage)
    }
    
    private let templateImages: [UIImage] = SportKind.soccer.backgrounds.map({ UIImage(resource: $0) })
    private let templateColors: [[Color]] = [
        [.white, .red, .darkBlue, .yellow],
        [.lightBlue, .green, .pink, .orange]
    ]
    
    @State private var selectedBackground: BackgroundType?
    
    @ObservedObject var vm: EditorViewModel
    let content: GenerativeContent
    
    init(
        vm: EditorViewModel,
        @ViewBuilder content: @escaping () -> GenerativeContent
    ) {
        self.vm = vm
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 12.adaptive()) {
            HStack(spacing: 0) {
                Button {
                    vm.cancelLastChanges()
                } label: {
                    Image(.crossButton)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 34.adaptive(), height: 34.adaptive())
                }
                .disabled(vm.editingImage == nil)
                .opacity(vm.editingImage == nil ? 0.5 : 1)
                
                Spacer()
                
                ForEach(BackgroundTab.allCases, id: \.self) { type in
                    Text(type.title)
                        .font(.poppins(13.adaptive()))
                        .foregroundStyle(vm.backgroundTab == type ? .lightYellow : .white)
                        .contentShape(.rect)
                        .onTapGesture {
                            vm.backgroundTab = type
                        }
                
                    Spacer()
                }
                
                Button {
                    vm.saveLastChanges()
                } label: {
                    Image(.checkButton)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 34.adaptive(), height: 34.adaptive())
                }
                .disabled(vm.editingImage == nil)
                .opacity(vm.editingImage == nil ? 0.5 : 1)
            }
            .padding(.horizontal, 16.adaptive())
            .padding(.bottom, 4.adaptive())
            
            switch vm.backgroundTab {
            case .color:
                colorsView
            case .image:
                imagesView
            case .generated:
                content
                    .padding(.horizontal, 16.adaptive())
            }
        }
    }
    
    var colorsView: some View {
        HStack(spacing: 20.adaptive()) {
            Button {
                vm.changeBackground(.clear)
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
                                    vm.changeBackground(.color(color))
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
                        if let data = try? await item.loadTransferable(type: Data.self) {
                            let storedImage = StoredImage(context: viewContext)
                            storedImage.data = data
                            
                            if viewContext.hasChanges {
                                withAnimation {
                                    try! viewContext.save()
                                }
                            }
                        } else {
                            print("Failed")
                        }
                        pickerItem = nil
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
                            vm.changeBackground(.image(uiImage))
                            selectedBackground = .image(uiImage)
                        }
                }
            }
            .padding(.horizontal, 16.adaptive())
        }
    }
}
