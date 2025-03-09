//
//  EditorTutorialView.swift
//  PhotoEditor
//

import SwiftUI

struct EditorTutorialView: View {
    
    @State private var selectedIndex: Int = 0
    
    let tips: [TutorialTip]
    var showFinalButton: Bool = false
    let onDismiss: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            TabView(selection: $selectedIndex) {
                ForEach(0..<tips.count, id: \.self) { index in
                    let buttonType: TutorialButtonType? = index < tips.count - 1 ? .next : (showFinalButton ? .final : nil)
                    TipCellView(tip: tips[index], buttonType: buttonType, onClose: onDismiss) {
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
