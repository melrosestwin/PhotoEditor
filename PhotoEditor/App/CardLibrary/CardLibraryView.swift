//
//  CardLibraryView.swift
//  PhotoEditor
//

import SwiftUI

struct CardLibraryView: View {
    
    @State private var showTutorial: Bool = false

    let sport: SportKind
    
    var body: some View {
        VStack(spacing: 32.adaptive()) {
            Text(sport.title)
                .font(.mazzard(24))
                .foregroundStyle(.white)
                .padding(.top, 6.adaptive())
                .frame(width: 164.adaptive(), height: 48.adaptive(), alignment: .center)
                .background(.titleBackground)
                .border(.lightYellow, width: 1)
                .animation(.default, value: sport)
            
            recentProjectScroll
            
            templatesScroll
            
            Spacer()
        }
        .padding(.vertical, 6.adaptive())
        .background(alignment: .center) { 
            Image(.mainBackground)
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity)
                .ignoresSafeArea()
        }
        .overlay {
            if showTutorial {
                EditorTutorialView(tips: TutorialTip.libraryTips) {
                    withAnimation {
                        showTutorial = false
                    }
                }
            }
        }
        .navigationContent(title: "Card library")
        
    }
    
    var recentProjectScroll: some View {
        VStack(spacing: 16.adaptive()) {
            Text("RECENT PROJECTS")
                .font(.mazzard(15))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 32.adaptive())
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16.adaptive()) {
//                    ForEach([], id: \.self) { image in
//                        ProjectCardView(image: image)
//                    }
                    
                    createButton
                }
                .padding(.horizontal, 32.adaptive())
            }
            .frame(height: 172.adaptive())
            .scrollDisabled(true)
        }
    }
    
    var templatesScroll: some View {
        VStack(spacing: 16.adaptive()) {
            Text("TEMPLATES")
                .font(.mazzard(15))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 32.adaptive())
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16.adaptive()) {
                    ForEach(sport.templateImages, id: \.self) { image in
                        ProjectCardView(image: image)
                    }
                }
                .padding(.horizontal, 32.adaptive())
            }
            .frame(height: 172.adaptive())
        }
    }
    
    var createButton: some View {
        NavigationLink(destination: Text("sdf")) {
            Color.clear
                .overlay {
                    Image(.plus)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45.adaptive())
                }
                .clipShape(.rect(cornerRadius: 10.adaptive()))
                .aspectRatio(CGSize(width: 118, height: 148), contentMode: .fit)
                .padding(.vertical, 11.adaptive())
                .padding(.leading, 10.adaptive())
                .padding(.trailing, 13.adaptive())
                .background(Color.black.opacity(0.56))
                .overlay {
                    RoundedRectangle(cornerRadius: 14.adaptive())
                        .inset(by: 1.adaptive())
                        .stroke(LinearGradient.yellow, lineWidth: 2.adaptive())
                }
        }
    }
}

#Preview {
    NavigationStack {
        CardLibraryView(sport: .soccer)
    }
}
