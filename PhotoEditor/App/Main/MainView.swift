//
//  MainView.swift
//  PhotoEditor
//

import SwiftUI

struct MainView: View {
    
    @State private var selectedItem: Athlete = .soccer
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12.adaptive()) {
                Text(selectedItem.title)
                    .font(.mazzard(24))
                    .foregroundStyle(.white)
                    .padding(.top, 6.adaptive())
                    .frame(width: 164.adaptive(), height: 48.adaptive(), alignment: .center)
                    .background(.titleBackground)
                    .border(.lightYellow, width: 1)
                    .padding(.top, 12.adaptive())
                    .animation(.default, value: selectedItem)
                
                TabView(selection: $selectedItem) {
                    ForEach(Athlete.allCases, id: \.self) { item in
                        Image(item.icon)
                            .resizable()
                            .scaledToFit()
                            .aspectRatio(CGSize(width: 210, height: 500), contentMode: .fit)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.default, value: selectedItem)
                .allowsHitTesting(false)
                .overlay {
                    pageButtons
                        .padding(.horizontal, 24.adaptive())
                }
                
                Spacer(minLength: 100)
                
                YellowButton(title: "START") {
                    
                }
                .padding(.horizontal, 42.adaptive())
                .padding(.bottom, 10.adaptive())
            }
            .background(alignment: .center) {
                Image(.mainBackground)
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .ignoresSafeArea()
            }
        }
    }
    
    var pageButtons: some View {
        HStack {
            Button {
                switch selectedItem {
                case .soccer: selectedItem = .baseball
                case .boxing: selectedItem = .soccer
                case .baseball: selectedItem = .boxing
                }
            } label: {
                Image(.leftArrow)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50.adaptive(), height: 50.adaptive())
            }
            
            Spacer()
            
            Button {
                switch selectedItem {
                case .soccer: selectedItem = .boxing
                case .boxing: selectedItem = .baseball
                case .baseball: selectedItem = .soccer
                }
            } label: {
                Image(.rightArrow)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50.adaptive(), height: 50.adaptive())
            }
        }
    }
}

#Preview {
    MainView()
}
