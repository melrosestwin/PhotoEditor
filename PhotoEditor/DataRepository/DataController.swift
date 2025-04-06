//
//  DataController.swift
//  Authenticator
//

import SwiftUI
import CoreData

class DataController: ObservableObject {
    
    static let shared = DataController()
        
    let container = NSPersistentContainer(name: "DataRepository")
    
    private init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
