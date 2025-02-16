//
//  TipCellView.swift
//  PhotoEditor
//

import SwiftUI

struct TipCellView: View {
    
    let tip: EditorTip
    let onClose: () -> Void
    let onNext: () -> Void
    
    var body: some View {
        ZStack {
            Image(.tipBackground)
                .resizable()
                .scaledToFit()
                .layoutPriority(1)
            
            VStack(spacing: 0) {
                Image(tip.banner)
                    .resizable()
                    .scaledToFit()
                    .layoutPriority(1)
                
                VStack(spacing: 0) {
                    (
                    Text(tip.colorfultText)
                        .font(.poppins(24.adaptive(), weight: .bold))
                        .foregroundColor(.lightYellow) +
                    Text(tip.simpleText)
                        .font(.poppins(16.adaptive()))
                        .foregroundColor(.white)
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 28.adaptive())
                .padding(.top, 12.adaptive())
                
                HStack {
                    if tip == .ready {
                        YellowButton(title: "START", action: onClose)
                            .padding(.horizontal, 10.adaptive())
                    } else {
                        Spacer()
                        
                        Button {
                            onNext()
                        } label: {
                            Image(.rightArrow)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50.adaptive(), height: 50.adaptive())
                        }
                    }
                }
                .padding(.horizontal, 24.adaptive())
                .padding(.bottom, 22.adaptive())
            }
            .overlay(alignment: .topTrailing) {
                Button {
                    onClose()
                } label: {
                    Image(.closeButton)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28.adaptive(), height: 28.adaptive())
                }
                .padding([.top, .trailing], 22.adaptive())
            }
        }
        .clipShape(.rect(cornerRadius: 27.adaptive()))
        .overlay {
            RoundedRectangle(cornerRadius: 27.adaptive())
                .inset(by: 0.5)
                .stroke(.darkYellow, lineWidth: 1)
        }
    }
}
