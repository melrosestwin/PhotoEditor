//
//  EditorViewModel.swift
//  PhotoEditor
//

import SwiftUI
import CoreData

enum EditingStep: Int, CaseIterable {
    case tip
    case brush
    case generate
}

@MainActor
final class EditorViewModel: ObservableObject {
    
    let apiManager: APIManager = APIManager()
    
    var projectId: NSManagedObjectID? = nil
    let sportKind: SportKind
    let originalImage: UIImage
    
    // LAYOUT
    @Published var selectedTab: EditorTab = .background
    @Published var backgroundTab: BackgroundTab = .color
    @Published var showBrushTip: Bool = false
    @Published var showTutorial: Bool = false
    @Published var isLoading: Bool = false
    @Published var isFocused: Bool = false
    
    // CANVAS
    @Published var canvasPaths: [BrushPath] = []
    @Published var pathPoints: [CGPoint] = []
    
    // SHARED
    @Published var sliderValue: Double = 0.5
    @Published var selectedTool: CanvasTool = .brush
    
    @Published var imageHistory: [UIImage] = []
    @Published var cancelledHistory: [UIImage] = []
    @Published var editingImage: UIImage?
    
    var lastImage: UIImage {
        return imageHistory.last ?? originalImage
    }
    
    var brushWidth: CGFloat {
        sliderValue * 49 + 1
    }
    
    init(image: UIImage, sportKind: SportKind) {
        self.originalImage = image
        self.sportKind = sportKind
    }
    
    init(project: Project) {
        self.originalImage = project.originalImage ?? UIImage(resource: .tipBanner4)
        self.sportKind = project.sportKind
        self.projectId = project.objectID
        self.imageHistory = project.history
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
        if let image = editingImage {
            imageHistory.append(image)
            editingImage = nil
        }
    }
    
    func cancelLastChanges() {
        editingImage = nil
    }
    
    func changeBackground(_ background: BackgroundType) {
        Task {
            do {
                isLoading = true
                var resultData: Data
                switch background {
                case .color(let color):
                    let id = try await apiManager.replaceBackground(for: lastImage, with: "Background of \(color.toHex() ?? "") color")
                    resultData = try await apiManager.fetchResults(generationId: id)
                case .image(let uIImage):
                    let id = try await apiManager.replaceBackground(for: lastImage, with: uIImage)
                    resultData = try await apiManager.fetchResults(generationId: id)
                case .prompt(let prompt):
                    let id = try await apiManager.replaceBackground(for: lastImage, with: prompt)
                    resultData = try await apiManager.fetchResults(generationId: id)
                case .clear:
                    resultData = try await apiManager.removeBackground(for: lastImage)
                }
                editingImage = UIImage(data: resultData)
                isLoading = false
            } catch {
                print(error)
                isLoading = false
            }
            
        }
    }
    
    func inpaint(prompt: String) {
        let image = editingImage ?? lastImage
        let text = selectedTab.initialPrompt + prompt
        let mask = ImageRenderer(content: RenderingCanvasView(paths: canvasPaths)
            .frame(width: image.size.width, height: image.size.height)).uiImage
        Task {
            do {
                isLoading = true
                let resultData = try await apiManager.inpaint(for: image, with: text, using: mask)
                editingImage = UIImage(data: resultData)
                isLoading = false
            } catch {
                print(error)
                isLoading = false
            }
            
        }
    }
    
    func cropImage(_ cropType: CropType) {
        let originalImage = lastImage
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
        self.editingImage = originalImage.cropped(to: CGRect(origin: origin, size: cropSize))
    }
    
    
    func undo() {
        if !imageHistory.isEmpty {
            cancelledHistory.append(imageHistory.removeLast())
        }
    }
    
    func redo() {
        if !cancelledHistory.isEmpty {
            imageHistory.append(cancelledHistory.removeLast())
        }
    }
    
    func onBrushChange(_ value: DragGesture.Value) {
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

