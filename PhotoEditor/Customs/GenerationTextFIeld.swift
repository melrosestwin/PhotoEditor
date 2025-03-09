//
//  GenerationTextFIeld.swift
//  PhotoEditor
//

import SwiftUI

struct GenerationTextFIeld: View {
    
    let placeholder: String
    @Binding var text: String
    let onGenerate: () -> Void
    
    @FocusState var isEditing: Bool
    
    var body: some View {
        HStack(spacing: 8.adaptive()) {
            TextField(placeholder, text: $text)
                .font(.poppins(12.adaptive()))
                .foregroundStyle(.white.opacity(0.85))
                .autocorrectionDisabled()
                .lineLimit(1)
            
            Button {
                
            } label: {
                Text("Generate")
                    .font(.poppins(14.adaptive()))
                    .foregroundStyle(.black)
                    .padding(.vertical, 10.adaptive())
                    .padding(.horizontal, 14.adaptive())
                    .background(LinearGradient.yellow)
                    .clipShape(.rect(cornerRadius: 10.adaptive()))
            }

        }
        .padding(.vertical, 5.adaptive())
        .padding(.leading, 15.adaptive())
        .padding(.trailing, 9.adaptive())
        .background(.white.opacity(0.28))
        .clipShape(.rect(cornerRadius: 10.adaptive()))
        .onTapGesture {
            isEditing = true
        }
    }
}
