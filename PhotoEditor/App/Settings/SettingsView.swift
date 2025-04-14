//
//  SettingsView.swift
//  PhotoEditor
//

import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        VStack(spacing: 16.adaptive()) {
            
            if let url = LinksManager.privacyUrl {
                Link(destination: url) {
                    settingRow("Privacy Policy")
                }
            }
            
            if let url = LinksManager.termsUrl {
                Link(destination: url) {
                    settingRow("Terms of Use")
                }
            }
            
            NavigationLink(destination: PurchasesView(button: .back)) {
                settingRow("Purchases")
            }
            
            Spacer()
        }
        .padding(.vertical, 24.adaptive())
        .padding(.horizontal, 16.adaptive())
        .setDefaultBackground(.secondary)
        .navigationContent(title: "Profile Page")
    }
    
    func settingRow(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.poppins(14.adaptive()))
                .foregroundStyle(.white)
            Spacer()
            Image(.forwardIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 16.adaptive(), height: 16.adaptive())
        }
        .padding(.vertical, 14.adaptive())
        .padding(.horizontal, 16.adaptive())
        .background {
            RoundedRectangle(cornerRadius: 14.adaptive(), style: .continuous)
                .fill(.white.opacity(0.28))
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
