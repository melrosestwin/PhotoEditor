//
//  EditorView.swift
//  PhotoEditor
//

import SwiftUI

struct EditorView: View {
    
    @StateObject var vm: EditorViewModel
    
    init(image: UIImage) {
        self._vm = StateObject(wrappedValue: EditorViewModel(image: image))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            VStack {
                GeometryReader { geometry in
                    
                    let minWidth = min(geometry.size.height * vm.croppedSize.imageSize, geometry.size.width)
                    let minHeight = min(geometry.size.width / vm.croppedSize.imageSize, geometry.size.height)
                    
                    Image(uiImage: .editorPlaceholder)
                        .resizable()
                        .scaledToFill()
                        .frame(width: minWidth, height: minHeight)
                        .clipped()
                        .overlay {
                            if vm.selectedTab != .size {
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
                        .padding(.horizontal, (geometry.size.width - minWidth) / 2)
                        .padding(.vertical, (geometry.size.height - minHeight) / 2)
                }
            }
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
        .background {
            Image(.secondaryBackground)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .ignoresSafeArea(edges: .top)
        .overlay {
            if vm.showTutorial {
                EditorTutorialView(tips: TutorialTip.editorTips, showFinalButton: true) {
                    withAnimation {
                        vm.showTutorial = false
                    }
                }
            }
        }
        .navigationContent(title: "") {
            navigationTrailingButtons
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
//            .disabled(vm.canvasPaths.isEmpty)
//            .opacity(vm.canvasPaths.isEmpty ? 0.5 : 1)
            
            Button {
                vm.redo()
            } label: {
                Image(.next)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34.adaptive(), height: 34.adaptive())
            }
//            .disabled(vm.cancelledPaths.isEmpty)
//            .opacity(vm.cancelledPaths.isEmpty ? 0.5 : 1)
            
            Spacer()
            
            if vm.selectedTab != .size {
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
            case .size:
                CropToolView(type: vm.croppedSize) { type in
                    vm.croppedSize = type
                }
            default:
                BrandSlider(value: $vm.sliderValue)
                Spacer()
                textField
                Spacer()
            }
        }
        .padding(.vertical, 16.adaptive())
        .frame(height: 210.adaptive())
        .padding(.horizontal, 28.adaptive())
    }
    
    var saveButtons: some View {
        HStack {
            
        }
    }
    
    var textField: some View {
        Group {
            if vm.showBrushTip {
                brushTip
            } else {
                Text("Describe the object you want to insert")
                    .font(.poppins(14.adaptive()))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                GenerationTextFIeld(placeholder: "Football uniform, black and yellow", text: $vm.promptText) {
                    
                }
            }
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
                        withAnimation {
                            vm.selectedTab = tool
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
                
            } label: {
                Image(.delete)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34.adaptive(), height: 34.adaptive())
            }
            Button {
                
            } label: {
                Image(.save)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34.adaptive(), height: 34.adaptive())
            }
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
}

#Preview {
    NavigationStack {
        EditorView(image: .editorPlaceholder)
    }
}
