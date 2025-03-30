//
//  CropToolView.swift
//  PhotoEditor
//

import SwiftUI

enum CropType: Int, CaseIterable {
    case square
    case vertical
    case horizontal
    
    var title: String {
        switch self {
        case .square: "1:1"
        case .vertical: "9:16"
        case .horizontal: "16:9"
        }
    }
    
    var ratio: CGFloat {
        switch self {
        case .square: return 1
        case .vertical: return 9 / 16
        case .horizontal: return 16 / 9
        }
    }
    
    var cardSize: CGSize {
        switch self {
        case .square: CGSize(width: 80.adaptive(), height: 80.adaptive())
        case .vertical: CGSize(width: 80.adaptive(), height: 100.adaptive())
        case .horizontal: CGSize(width: 100.adaptive(), height: 80.adaptive())
        }
    }
}

struct CropToolView: View {
    
    @State private var cropType: CropType?
    
    @ObservedObject var vm: EditorViewModel
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Button {
                    cropType = nil
                    vm.cancelLastChanges()
                } label: {
                    Image(.crossButton)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 34.adaptive(), height: 34.adaptive())
                }
                .disabled(vm.editingImage == nil)
                .opacity(vm.editingImage == nil ? 0 : 1)
                
                Spacer()
                
                Button {
                    cropType = nil
                    vm.saveLastChanges()
                } label: {
                    Image(.checkButton)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 34.adaptive(), height: 34.adaptive())
                }
                .disabled(vm.editingImage == nil)
                .opacity(vm.editingImage == nil ? 0 : 1)
            }
            
            HStack(alignment: .bottom, spacing: 17.adaptive()) {
                Spacer(minLength: 0)
                ForEach(CropType.allCases, id: \.self) { type in
                    RoundedRectangle(cornerRadius: 5.adaptive(), style: .continuous)
                        .fill(.white.opacity(0.18))
                        .frame(width: type.cardSize.width, height: type.cardSize.height)
                        .overlay {
                            Text(type.title)
                                .font(.mazzard(12.adaptive()))
                                .foregroundStyle(.white)
                        }
                        .overlay {
                            if cropType == type {
                                RoundedRectangle(cornerRadius: 5.adaptive(), style: .continuous)
                                    .inset(by: 0.5)
                                    .stroke(.lightYellow, lineWidth: 1)
                            }
                        }
                        .onTapGesture {
                            cropType = type
                            vm.cropImage(type)
                        }
                }
                Spacer(minLength: 0)
            }
        }
    }
}
