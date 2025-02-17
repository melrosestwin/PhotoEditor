//
//  EditorTutorialView.swift
//  PhotoEditor
//

import SwiftUI

struct EditorTutorialView: View {
    
    @State private var selectedIndex: Int = 0
    
    let tips: [TutorialTip]
    let onDismiss: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            TabView(selection: $selectedIndex) {
                ForEach(0..<tips.count, id: \.self) { index in
                    TipCellView(tip: tips[index], onClose: onDismiss) {
                        if selectedIndex < tips.count - 1 {
                            selectedIndex += 1
                        } else {
                            onDismiss()
                        }
                    }
                    .padding(.horizontal, 40.adaptive())
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.default, value: selectedIndex)
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
    EditorTutorialView(tips: TutorialTip.editorTips) {
        
    }
}
