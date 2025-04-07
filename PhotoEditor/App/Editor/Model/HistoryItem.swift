import Foundation
import CoreData

class HistoryItem: NSObject, NSCoding, Identifiable {
    var id: UUID = UUID()
    var image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(image.pngData(), forKey: "image")
    }

    public required init?(coder: NSCoder) {
        let rawValue = coder.decodeObject(forKey: "role") as? String ?? ""

        id = coder.decodeObject(forKey: "id") as? UUID ?? UUID()
        if let data = coder.decodeObject(forKey: "image") as? Data,
           let image = UIImage(data: data) {
            self.image = image
        } else {
            self.image = UIImage()
        }
    }
}

class HistoryItemTransformer: NSSecureUnarchiveFromDataTransformer {

    override class var allowedTopLevelClasses: [AnyClass] {
        return [NSArray.self, HistoryItem.self]
    }

    override class func transformedValueClass() -> AnyClass {
        return NSArray.self
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let messages = value as? [HistoryItem] else {
            return nil
        }

        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: messages, requiringSecureCoding: true)
            return super.transformedValue(data)
        } catch {
            print("Failed to archive ChatMessages: \(error)")
            return nil
        }
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = super.reverseTransformedValue(value) as? Data else {
            return nil
        }

        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, HistoryItem.self], from: data) as? [HistoryItem]
        } catch {
            print("Failed to unarchive ChatMessages: \(error)")
            return nil
        }
    }
}