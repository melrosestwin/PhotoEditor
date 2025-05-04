//
//  EditorView.swift
//  PhotoEditor
//

import SwiftUI

enum EditorAlert: Int, CaseIterable {
    case dismiss
    case delete
    
    var title: String {
        switch self {
        case .dismiss:
            return "Discard changes?"
        case .delete:
            return "Delete project?"
        }
    }
    
    var message: String {
        switch self {
        case .dismiss:
            return "Any unsaved changes will be lost."
        case .delete:
            return "This action cannot be undone."
        }
    }
}

struct EditorView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @StateObject var vm: EditorViewModel
    
    @State private var showDismissAlert: Bool = false
    @State private var showDeleteAlert: Bool = false
    
    private var canSave: Bool {
        if vm.projectId == nil {
            return true
        } else {
            return vm.projectHistory != vm.imageHistory
        }
    }
    
    private var canDelete: Bool {
        if let id = vm.projectId, viewContext.registeredObject(for: id) != nil {
            return true
        }
        return false
    }
    
    init(project: Project) {
        self._vm = StateObject(wrappedValue: EditorViewModel(project: project))
    }
    
    init(image: UIImage, sportKind: SportKind) {
        self._vm = StateObject(wrappedValue: EditorViewModel(image: image, sportKind: sportKind))
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                VStack(alignment: .center, spacing: 0) {
                    Spacer(minLength: 0)
                    Image(uiImage: vm.editingImage ?? vm.lastImage)
                        .resizable()
                        .scaledToFit()
                        .background(GeometryReader { geometry in
                            Color.clear
                                .preference(key: ViewSizeKey.self, value: geometry.size)
                        })
                        .onPreferenceChange(ViewSizeKey.self) { newSize in
                            vm.editingImageSize = newSize
                        }
                        .overlay {
                            if vm.selectedTab == .insert || vm.selectedTab == .outfit {
                                Canvas { context, size in
                                    context.blendMode = .destinationAtop
                                    vm.canvasPaths.forEach { path in
                                        context.stroke(path.path, with: .color(path.tool.color), style: .init(lineWidth: path.lineWidth, lineCap: .round, lineJoin: .round))
                                    }
                                    context.stroke(vm.currentPath, with: .color(vm.selectedTool.color), style: .init(lineWidth: vm.brushWidth, lineCap: .round, lineJoin: .round))
                                }
                                .gesture(
                                    DragGesture()
                                        .onChanged(vm.onBrushChange(_:))
                                        .onEnded(vm.onBrushEnd(_:))
                                )
                            }
                        }
                                    
                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity)
                .overlay(alignment: .bottom) {
                    editingTools
                        .padding(.horizontal, 16.adaptive())
                        .padding(.bottom, 10.adaptive())
                }
                .overlay {
                    if vm.isLoading {
                        loadingView
                    }
                }
                
                currentToolView
                
                toolBar
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .setDefaultBackground(.secondary)
            .frame(height: UIScreen.main.bounds.height - safeAreaInsets.bottom)
            .overlay {
                Group {
                    if vm.showTutorial {
                        EditorTutorialView(tips: TutorialTip.editorTips, showFinalButton: true) {
                            withAnimation {
                                vm.showTutorial = false
                            }
                        }
                    }
                }
                .animation(.default, value: vm.showTutorial)
            }
            .fullScreenCover(isPresented: $vm.showPurchasesScreen) {
                PurchasesView(button: .close)
            }
            .alert("Discard changes?", isPresented: $showDismissAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Leave", role: .destructive) {
                    dismiss()
                }
            } message: {
                Text("Are you sure that you want to leave? Any unsaved changes will be lost.")
            }
        }
        .scrollDisabled(!vm.isFocused)
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    if canSave {
                        showDismissAlert = true
                    } else {
                        dismiss()
                    }
                } label: {
                    HStack(spacing: 5.adaptive()) {
                        Image(systemName: "chevron.left")
                        Text("Return")
                            .font(.poppins(17.adaptive()))
                    }
                    .foregroundStyle(.white)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                navigationTrailingButtons
            }
        }
    }
    
    var editingTools: some View {
        HStack(spacing: 10.adaptive()) {
            Button {
                vm.undo()
            } label: {
                Image(.previous)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34.adaptive(), height: 34.adaptive())
            }
            .disabled(vm.imageHistory.isEmpty)
            .opacity(vm.imageHistory.isEmpty ? 0.5 : 1)
            
            Button {
                vm.redo()
            } label: {
                Image(.next)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34.adaptive(), height: 34.adaptive())
            }
            .disabled(vm.cancelledHistory.isEmpty)
            .opacity(vm.cancelledHistory.isEmpty ? 0.5 : 1)
            
            Spacer()
            
            if vm.selectedTab == .insert || vm.selectedTab == .outfit {
                ForEach(CanvasTool.allCases, id: \.self) { tool in
                    Image(tool.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 34.adaptive(), height: 34.adaptive())
                        .opacity(vm.selectedTool == tool ? 1 : 0.6)
                        .onTapGesture {
                            vm.selectedTool = tool
                        }
                }
            }
        }
    }
    
    var currentToolView: some View {
        VStack(spacing: 12.adaptive()) {
            
            switch vm.selectedTab {
            case .background:
                BackgroundToolView(vm: vm) {
                    generationField
                }
                
            case .size:
                CropToolView(vm: vm)
                    .padding(.horizontal, 16.adaptive())
                
                Spacer()
            case .insert:
                cancelSaveButtons
                    .padding(.horizontal, 16.adaptive())
                
                generationField
                    .padding(.horizontal, 16.adaptive())
            case .outfit:
                cancelSaveButtons
                    .padding(.horizontal, 16.adaptive())
                
                generationField
                    .padding(.horizontal, 16.adaptive())
            }
        }
        .padding(.vertical, 16.adaptive())
        .frame(height: 180.adaptive())
    }
    
    var cancelSaveButtons: some View {
        HStack(spacing: 12.adaptive()) {
            Button {
                vm.cancelLastChanges()
            } label: {
                Image(.crossButton)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34.adaptive(), height: 34.adaptive())
            }
            .disabled(vm.editingImage == nil)
            .opacity(vm.editingImage == nil ? 0.5 : 1)
            
            BrandSlider(value: $vm.sliderValue)
            
            Button {
                vm.saveLastChanges()
            } label: {
                Image(.checkButton)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34.adaptive(), height: 34.adaptive())
            }
            .disabled(vm.editingImage == nil)
            .opacity(vm.editingImage == nil ? 0.5 : 1)
        }
    }
    
    var generationField: some View {
        Group {
            Spacer(minLength: 0)
            
            Text("Describe the object you want to insert")
                .font(.poppins(14.adaptive()))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            GenerationTextField(isFocused: $vm.isFocused, placeholder: vm.selectedTab.generatorPlaceholder) { prompt in
                switch vm.selectedTab {
                case .background:
                    vm.changeBackground(.prompt(prompt))
                case .insert, .outfit:
                    vm.inpaint(prompt: prompt)
                case .size: break
                }
            }
            .ignoresSafeArea(.keyboard)
        }
    }
    
    var toolBar: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color(hex: 0xF3CA2B).opacity(0.38))
                .frame(height: 1)
            
            HStack(spacing: 2.adaptive()) {
                ForEach(EditorTab.allCases, id: \.self) { tool in
                    VStack(spacing: 2.adaptive()) {
                        Image(tool.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 36.adaptive())
                        
                        Text(tool.title)
                            .font(.poppins(10.adaptive()))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                            .frame(height: 28.adaptive())
                    }
                    .padding(.vertical, 4)
                    .frame(width: 80.adaptive(), height: 70.adaptive())
                    .contentShape(.rect)
                    .background {
                        if vm.selectedTab == tool {
                            RadialGradient(
                                colors: [.clear, .darkYellow.opacity(0.2)],
                                center: .center,
                                startRadius: 0,
                                endRadius: 35
                            )
                            RoundedCornerShape(cornerRadius: 10.adaptive(), corners: [.bottomLeft, .bottomRight])
                                .stroke(.darkYellow.opacity(0.4))
                        }
                    }
                    .onTapGesture {
                        if vm.selectedTab != tool, vm.editingImage == nil, !vm.isLoading {
                            withAnimation {
                                vm.selectedTab = tool
                            }
                        }
                    }
                }
            }
        }
        .padding(.bottom, 4.adaptive())
    }
    
    var brushTip: some View {
        HStack(spacing: 12.adaptive()) {
            Image(.brushTipIcon)
                .resizable()
                .scaledToFit()
                .frame(height: 28.adaptive())
            
            Text("Brush over the image to select the area to insert the object.")
                .font(.poppins(10.adaptive()))
                .foregroundStyle(.white)
        }
    }
    
    var navigationTrailingButtons: some View {
        HStack(spacing: 8.adaptive()) {
            Button {
                showDeleteAlert = true
            } label: {
                Image(.delete)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34.adaptive(), height: 34.adaptive())
            }
            .disabled(!canDelete)
            .opacity(!canDelete ? 0.5 : 1)
            .alert("Delete project?", isPresented: $showDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    deleteProject()
                }
            } message: {
                Text("Are you sure that you want to delete the project? This action cannot be undone.")
            }

            
            Button {
                saveProject()
            } label: {
                Image(.save)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34.adaptive(), height: 34.adaptive())
            }
            .disabled(!canSave)
            .opacity(!canSave ? 0.5 : 1)
        }
        .padding(.trailing, 8.adaptive())
    }
    
    var loadingView: some View {
        Color.black
            .opacity(0.5)
            .overlay {
                ProgressView()
            }
    }
    
    func deleteProject() {
        if let id = vm.projectId, let existingProject = try? viewContext.existingObject(with: id) as? Project {
            viewContext.delete(existingProject)
            saveChanges()
        }
        dismiss()
    }
    
    func saveProject() {
        var project: Project
        if let id = vm.projectId, let existingProject = try? viewContext.existingObject(with: id) as? Project {
            project = existingProject
        } else {
            project = Project(context: viewContext)
            project.dateCreate = Date()
            vm.projectId = project.objectID
        }
        project.originalImage = vm.originalImage
        project.sportKind = vm.sportKind
        project.history = vm.imageHistory
        project.dateChange = Date()
        vm.cancelledHistory = []
        
        saveChanges()
        dismiss()
    }
    
    func saveChanges() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    NavigationStack {
        EditorView(image: .editorPlaceholder, sportKind: .soccer)
    }
}
