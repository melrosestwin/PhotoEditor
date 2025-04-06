//
//  GenerationTextFIeld.swift
//  PhotoEditor
//

import SwiftUI

struct GenerationTextField: View {
    
    @State private var text: String = ""
    @Binding var isFocused: Bool
    let placeholder: String
    let onGenerate: (String) -> Void
    
    @FocusState private var isEditing: Bool
    
    var body: some View {
        HStack(spacing: 8.adaptive()) {
            TextField(placeholder, text: $text)
                .font(.poppins(12.adaptive()))
                .foregroundStyle(.white.opacity(0.85))
                .autocorrectionDisabled()
                .lineLimit(1)
                .focused($isEditing)
            
            Button {
                onGenerate(text)
            } label: {
                Text("Generate")
                    .font(.poppins(14.adaptive()))
                    .foregroundStyle(.black)
                    .padding(.vertical, 10.adaptive())
                    .padding(.horizontal, 14.adaptive())
                    .background(LinearGradient.yellow)
                    .clipShape(.rect(cornerRadius: 10.adaptive()))
            }
            .disabled(text.isEmpty)
        }
        .padding(.vertical, 5.adaptive())
        .padding(.leading, 15.adaptive())
        .padding(.trailing, 9.adaptive())
        .background(.white.opacity(0.28))
        .clipShape(.rect(cornerRadius: 10.adaptive()))
        .onChange(of: isEditing) { newValue in
            isFocused = newValue
        }
        .onTapGesture {
            isEditing = true
        }
    }
}
