//
//  MainView.swift
//  PhotoEditor
//

import SwiftUI

struct MainView: View {
    
    @State private var selectedSport: SportKind = .soccer
    @State private var showTutorial: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12.adaptive()) {
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(.clear)
                        .aspectRatio(1, contentMode: .fit)
                    
                    Spacer(minLength: 0)
                    
                    Text(selectedSport.title)
                        .font(.mazzard(24))
                        .foregroundStyle(.white)
                        .padding(.top, 6.adaptive())
                        .frame(width: 164.adaptive(), height: 48.adaptive(), alignment: .center)
                        .background(.titleBackground)
                        .border(.lightYellow, width: 1)
                        .animation(.default, value: selectedSport)
                    
                    Spacer(minLength: 0)
                    
                    NavigationLink(destination: SettingsView()) {
                        Image(.profileIcon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48.adaptive(), height: 48.adaptive())
                            .shadow(color: Color(hex: 0xD57700), radius: 13.adaptive())
                    }
                }
                .frame(height: 48.adaptive())
                .padding(.top, 12.adaptive())
                .padding(.horizontal, 16.adaptive())
                
                TabView(selection: $selectedSport) {
                    ForEach(SportKind.allCases, id: \.self) { item in
                        Image(item.athleteIcon)
                            .resizable()
                            .scaledToFit()
                            .aspectRatio(CGSize(width: 210, height: 500), contentMode: .fit)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.default, value: selectedSport)
                .allowsHitTesting(false)
                .overlay {
                    pageButtons
                        .padding(.horizontal, 24.adaptive())
                }
                
                Spacer(minLength: 100)
                
                NavigationLink(destination: CardLibraryView(sport: selectedSport)) {
                    Text("START")
                        .font(.mazzard(24.adaptive()))
                        .foregroundStyle(.buttonTitle)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60.adaptive())
                        .background {
                            LinearGradient(
                                colors: [.lightYellow, .darkYellow],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .shadow(color: .orangeShadow, radius: 12, x: 0, y: 0)
                        }
                        .clipShape(.rect(cornerRadius: 15.adaptive()))
                }
                .padding(.horizontal, 42.adaptive())
                .padding(.bottom, 10.adaptive())
            }
            .setDefaultBackground(.primary)
            .overlay {
                if showTutorial {
                    EditorTutorialView(tips: TutorialTip.editorTips) {
                        withAnimation {
                            showTutorial = false
                        }
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
        .environment(\.managedObjectContext, DataController.shared.container.viewContext)
    }
    
    var pageButtons: some View {
        HStack {
            Button {
                switch selectedSport {
                case .soccer: selectedSport = .cricket
                case .boxing: selectedSport = .soccer
                case .cricket: selectedSport = .boxing
                }
            } label: {
                Image(.leftArrow)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50.adaptive(), height: 50.adaptive())
            }
            
            Spacer()
            
            Button {
                switch selectedSport {
                case .soccer: selectedSport = .boxing
                case .boxing: selectedSport = .cricket
                case .cricket: selectedSport = .soccer
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
