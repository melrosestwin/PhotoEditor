//
//  CategoryPickerView.swift
//  Pillinko
//

import SwiftUI

struct BrandSinglePicker<T: Hashable, CellContent: View>: View {
    
    var items: [T]
    @Binding var selection: T
    @Binding var isOpen: Bool
    var title: String
    var content: (T) -> CellContent
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.system(size: 13.flexible()))
                .foregroundStyle(.brandGray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                UIApplication.shared.endEditing()
                withAnimation {
                    isOpen.toggle()
                }
            } label: {
                content(selection)
                    .overlay(alignment: .trailing) {
                        Image(systemName: "chevron.right")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 12.flexible())
                            .foregroundStyle(.brandGray)
                            .rotationEffect(.degrees(isOpen ? 90 : 0))
                    }
            }
            
            Rectangle()
                .fill(.brandGray)
                .frame(height: 1)
        }
        .padding(.horizontal, 16.flexible())
        .background(isOpen ? .white.opacity(0.05) : .clear)
        .overlay(alignment: .top) {
            if isOpen {
                VStack(spacing: 0) {
                    ForEach(items, id: \.self) { item in
                        
                        content(item)
                            .background(.white.opacity(0.01))
                            .onTapGesture {
                                selection = item
                                withAnimation {
                                    isOpen = false
                                }
                            }
                        
                        if item != items.last {
                            Rectangle()
                                .fill(.brandGray)
                                .frame(height: 1)
                        }
                    }
                }
                .padding(.horizontal, 16.flexible())
                .padding(.vertical, 8.flexible())
                .background(.thinMaterial)
                .clipShape(.rect(cornerRadius: 10.flexible()))
                .padding(.top, 62.flexible())
                .background {
                    Color.black
                        .opacity(0.001)
                        .frame(width: UIScreen.screenWidth, height: 1500.flexible())
                        .onTapGesture {
                            withAnimation {
                                isOpen = false
                            }
                        }
                }
            }
        }
    }
}
