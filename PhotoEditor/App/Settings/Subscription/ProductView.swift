//
//  ProductView.swift
//  PhotoEditor
//

import SwiftUI
import StoreKit

struct ProductView: View {
    
    let product: SKProduct
    let onBuy: () -> Void
    
    var preferences: [String] {
        return [
            product.localizedDescription,
            "Unlimited storage for finished photos",
            "Access to 3 types of sports (football, boxing, cricket)"
        ]
    }
    
    var body: some View {
        VStack(spacing: 12.adaptive()) {
            Text("\(product.localizedTitle) Plan".capitalized)
                .font(.poppins(16.adaptive(), weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 8.adaptive()) {
                ForEach(preferences, id: \.self) { preference in
                    preferenceView(preference)
                }
            }
            
            Text("$\(product.price)")
                .font(.poppins(24.adaptive(), weight: .medium))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button(action: onBuy) {
                Text("Buy")
                    .font(.poppins(16.adaptive(), weight: .black))
                    .foregroundStyle(.buttonTitle)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50.adaptive())
                    .background {
                        LinearGradient.yellow
                            .shadow(color: .orangeShadow, radius: 12, x: 0, y: 0)
                    }
                    .clipShape(.rect(cornerRadius: 15.adaptive()))
            }
        }
        .padding(.all, 16.adaptive())
        .background {
            RoundedRectangle(cornerRadius: 24.adaptive(), style: .continuous)
                .fill(.white.opacity(0.1))
        }
    }
    
    func preferenceView(_ text: String) -> some View {
        HStack(spacing: 8.adaptive()) {
            Image(.checkYellow)
                .resizable()
                .scaledToFit()
                .frame(width: 16.adaptive(), height: 16.adaptive())
            Text(text)
                .font(.poppins(14.adaptive()))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
