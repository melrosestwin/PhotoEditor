//
//  OnboardingView.swift
//  PhotoEditor
//

import SwiftUI

struct OnboardingView: View {
    
    @Binding var isFirstLaunch: Bool
    
    @State private var selectedItem: OnboardingItem = .create
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                TabView(selection: $selectedItem) {
                    ForEach(OnboardingItem.allCases, id: \.self) { item in
                        VStack(spacing: 0) {
                            Image(item.banner)
                                .resizable()
                                .scaledToFit()
                                .padding(.horizontal, 16.adaptive())
                            
                            Spacer(minLength: 0)
                        }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .aspectRatio(CGSize(width: 450, height: 600), contentMode: .fit)
                .animation(.default, value: selectedItem)
                .allowsHitTesting(false)
                
                Spacer()
                Spacer()
                Spacer()
            }
            
            LinearGradient(
                colors: [.clear, .clear, .clear, .black, .black, .black],
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack(spacing: 24.adaptive()) {
                Spacer()
                
                TabView(selection: $selectedItem) {
                    ForEach(OnboardingItem.allCases, id: \.self) { item in
                        VStack(spacing: 0) {
                            (
                            Text(item.colorfultText)
                                .font(.poppins(44.adaptive(), weight: .bold))
                                .foregroundColor(.lightYellow) +
                            Text(item.simpleText)
                                .font(.poppins(27.adaptive()))
                                .foregroundColor(.white)
                            )
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                            
                            Spacer(minLength: 0)
                        }
                        .padding(.horizontal, 36.adaptive())
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.default, value: selectedItem)
                .frame(height: 250.adaptive())
                
                if selectedItem == .choice {
                    YellowButton(title: "START") {
                        withAnimation {
                            isFirstLaunch = false
                        }
                    }
                    .padding([.bottom, .horizontal], 42.adaptive())
                } else {
                    nextButton
                        .padding([.bottom, .horizontal], 42.adaptive())
                }
            }
        }
        .background {
            Image(.onboardingBackground)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .ignoresSafeArea()
    }
    
    var nextButton: some View {
        HStack {
            Spacer()
            
            Button {
                withAnimation {
                    switch selectedItem {
                    case .create: selectedItem = .edit
                    case .edit: selectedItem = .choice
                    default: break
                    }
                }
            } label: {
                Image(.rightArrow)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70.adaptive(), height: 70.adaptive())
            }
        }
    }
}

#Preview {
    OnboardingView(isFirstLaunch: .constant(false))
}
