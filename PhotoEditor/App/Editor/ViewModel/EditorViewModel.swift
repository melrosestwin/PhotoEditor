//
//  EditorViewModel.swift
//  PhotoEditor
//

import SwiftUI

enum EditingStep: Int, CaseIterable {
    case tip
    case brush
    case generate
}

@MainActor
final class EditorViewModel: ObservableObject {
    
    let sportKind: SportKind
    var originalImage: UIImage
    
    // LAYOUT
    @Published var selectedTab: EditorTab = .background
    @Published var editingStep: EditingStep = .tip
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
    @Published var cropType: CropType = .square
    @Published var generatedImages: [UIImage] = SportKind.cricket.templateImages.map({ UIImage(resource: $0) })
    
    @Published var imageHistory: [UIImage] = []
    @Published var cancelledHistory: [UIImage] = []
    
    var displayImage: UIImage {
        return imageHistory.last ?? originalImage
    }
    
    var brushWidth: CGFloat {
        sliderValue * 49 + 1
    }
    
    init(image: UIImage, sportKind: SportKind) {
        self.originalImage = image
        self.sportKind = sportKind
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
    
    func saveLastChanges() {
//        if let image = editingImage {
//            imageHistory.append(image)
//            cancelledHistory.removeAll()
//        }
    }
    
    func cancelLastChanges() {
//        editingImage = imageHistory.last ?? originalImage
    }
    
    func cropImage() -> UIImage? {
        let originalImage = displayImage
        let originalSize = originalImage.size
        
        var cropSize: CGSize
        
        switch cropType {
        case .square:
            let min = min(originalSize.width, originalSize.height)
            cropSize = CGSize(width: min, height: min)
        case .vertical:
            let cropHeight = min(originalSize.width, originalSize.height / cropType.ratio)
            let cropWidth = cropHeight * cropType.ratio
            cropSize = CGSize(width: cropWidth, height: cropHeight)
        case .horizontal:
            let cropHeight = min(originalSize.height, originalSize.width / cropType.ratio)
            let cropWidth = cropHeight * cropType.ratio
            cropSize = CGSize(width: cropWidth, height: cropHeight)
        }
        
        let origin = CGPoint(x: (originalSize.width - cropSize.width) / 2, y: (originalSize.height - cropSize.height) / 2)
        return originalImage.cropped(to: CGRect(origin: origin, size: cropSize))
    }
    
    
    func undo() {
        
    }
    
    func redo() {
        
    }
    
    func onBrushChange(_ value: DragGesture.Value) {
        if editingStep == .tip {
            withAnimation {
                editingStep = .brush
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

extension UIImage {
    func copyFromData() -> UIImage? {
        if let pngData = self.pngData() {
            return UIImage(data: pngData)
        } else {
            return nil
        }
    }
    
    func cropped(to rect: CGRect) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        
        // Convert points to pixels
        let scale = self.scale
        let pixelRect = CGRect(
            x: rect.origin.x * scale,
            y: rect.origin.y * scale,
            width: rect.size.width * scale,
            height: rect.size.height * scale
        )
        
        guard let croppedCGImage = cgImage.cropping(to: pixelRect) else { return nil }
        return UIImage(cgImage: croppedCGImage, scale: scale, orientation: self.imageOrientation)
    }
}
