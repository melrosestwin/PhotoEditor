//
//  CardLibraryView.swift
//  PhotoEditor
//

import SwiftUI
import CoreData

struct CardLibraryView: View {
    
    @State private var showTutorial: Bool = false
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) var projects: FetchedResults<Project>

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
        .setDefaultBackground(.primary)
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
                    ForEach(projects, id: \.self) { project in
                        let image = project.history?.last?.image ?? project.originalImage ?? UIImage()
                        NavigationLink(destination: EditorView(project: project)) {
                            ProjectCardView(image: image)
                        }
                    }
                    
                    createButton
                }
                .padding(.horizontal, 32.adaptive())
            }
            .frame(height: 172.adaptive())
            .scrollDisabled(projects.isEmpty)
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
                    ForEach(sport.templateImages, id: \.self) { resource in
                        NavigationLink(destination: EditorView(image: UIImage(resource: resource), sportKind: sport)) {
                            ProjectCardView(resource: resource)
                        }
                    }
                }
                .padding(.horizontal, 32.adaptive())
            }
            .frame(height: 172.adaptive())
        }
    }
    
    var createButton: some View {
        NavigationLink {
            UploadPhotoView { image in
                saveProject(image)
            }
        } label: {
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
    
    func saveProject(_ image: UIImage) {
        let project = Project(context: viewContext)
        project.dateCreate = Date()
        project.dateChange = Date()
        project.originalImage = image
        project.history = []
        project.sportKind = sport
        
        if viewContext.hasChanges {
            withAnimation {
                do {
                    try viewContext.save()
                } catch {
                    print(error)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CardLibraryView(sport: .soccer)
    }
}
