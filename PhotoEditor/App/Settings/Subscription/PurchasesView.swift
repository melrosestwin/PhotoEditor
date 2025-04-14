//
//  PurchasesView.swift
//  PhotoEditor
//

import SwiftUI
import StoreKit

enum PurchaseCloseButton {
    case back
    case skip
    case close
}

struct PurchasesView: View {
    
    var button: PurchaseCloseButton
    @Environment(\.dismiss) var dismiss
    @StateObject var storeManager = StoreManager.shared
    
    var body: some View {
        VStack {
            Text("Purchases")
                .font(.poppins(17.adaptive(), weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .overlay(alignment: button == .back ? .leading : .trailing) {
                    Button {
                        dismiss()
                    } label: {
                        if button == .back {
                            HStack(spacing: 5.adaptive()) {
                                Image(systemName: "chevron.left")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18.adaptive(), height: 24.adaptive())
                                Text("Return")
                                    .font(.poppins(17.adaptive()))
                            }
                            .foregroundStyle(.white)
                        } else {
                            Text(button == .skip ? "Skip" : "Close")
                                .font(.poppins(17.adaptive()))
                                .foregroundStyle(.darkYellow)
                        }
                    }
                }
                .padding(.horizontal, 16.adaptive())
            
            ScrollView {
                VStack(spacing: 16.adaptive()) {
                    Text("*In the free plan you have 10 free generations")
                        .font(.poppins(14.adaptive()))
                        .foregroundStyle(.white.opacity(0.4))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ForEach(storeManager.products, id: \.self) { product in
                        ProductView(product: product) {
                            storeManager.buyProduct(product)
                        }
                    }
                    
                    HStack {
                        if let url = LinksManager.privacyUrl {
                            Link(destination: url) {
                                linkButton("Privacy Policy")
                            }
                        }
                        
                        if let url = LinksManager.termsUrl {
                            Link(destination: url) {
                                linkButton("Terms of Use")
                            }
                        }
                    }
                    .padding(.top, 16.adaptive())
                }
                .padding(.horizontal, 16.adaptive())
                .padding(.vertical, 16.adaptive())
            }
           
            Spacer()
        }
        .padding(.vertical, 10.adaptive())
        .ignoresSafeArea(edges: .bottom)
        .setDefaultBackground(.secondary)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func linkButton(_ title: String) -> some View {
        Text(title)
            .font(.poppins(14.adaptive()))
            .foregroundStyle(.darkYellow)
            .underline()
            .frame(maxWidth: .infinity)
    }
}
