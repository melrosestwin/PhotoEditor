//
//  EditorTutorialView.swift
//  PhotoEditor
//

import SwiftUI

struct EditorTutorialView: View {
    
    @State private var selectedTip: EditorTip = .welcome
    
    let onDismiss: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            TabView(selection: $selectedTip) {
                ForEach(EditorTip.allCases, id: \.self) { tip in
                    TipCellView(tip: tip, onClose: onDismiss) {
                        switch tip {
                        case .welcome: selectedTip = .sections
                        case .sections: selectedTip = .tools
                        case .tools: selectedTip = .selection
                        case .selection: selectedTip = .generation
                        case .generation: selectedTip = .addition
                        case .addition: selectedTip = .background
                        case .background: selectedTip = .ready
                        default: break
                        }
                    }
                    .padding(.horizontal, 40.adaptive())
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.default, value: selectedTip)
            .highPriorityGesture(DragGesture())
            
            Spacer()
        }
        .background {
            Color.black
                .opacity(0.6)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    EditorTutorialView {
        
    }
}
