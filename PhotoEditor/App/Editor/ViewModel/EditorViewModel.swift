//
//  EditorViewModel.swift
//  PhotoEditor
//

import SwiftUI

@MainActor
final class EditorViewModel: ObservableObject {
    
    var image: UIImage
    
    // LAYOUT
    @Published var selectedTab: EditorTab = .outfit
    @Published var showBrushTip: Bool = true
    @Published var showTutorial: Bool = false
    @Published var isLoading: Bool = false
    
    // CANVAS
    @Published var canvasPaths: [BrushPath] = []
    @Published var pathPoints: [CGPoint] = []
    
    // SHARED
    @Published var sliderValue: Double = 0.5
    @Published var selectedTool: CanvasTool = .brush
    @Published var promptText: String = ""
    
    // CHANGES
    @Published var croppedSize: CropType = .square
    
    init(image: UIImage) {
        self.image = image
    }
    
    var currentPath: Path {
        var path = Path()
        if let firstPoint = pathPoints.first {
            path.move(to: firstPoint)
            for point in pathPoints {
                path.addLine(to: point)
            }
        }
        return path
    }
    
    var brushWidth: CGFloat {
        sliderValue * 49 + 1
    }
    
    func undo() {
        
    }
    
    func redo() {
        
    }
    
    func onBrushChange(_ value: DragGesture.Value) {
        if showBrushTip {
            withAnimation {
                showBrushTip = false
            }
        }
        if pathPoints.isEmpty {
            pathPoints.append(value.startLocation)
        }
        pathPoints.append(value.location)
    }
    
    func onBrushEnd(_ value: DragGesture.Value) {
        pathPoints.append(value.location)
        canvasPaths.append(BrushPath(tool: selectedTool, points: pathPoints, lineWidth: brushWidth))
        pathPoints.removeAll()
    }
}
