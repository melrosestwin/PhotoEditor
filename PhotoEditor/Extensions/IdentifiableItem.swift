//
//  IdentifiableDate.swift
//  PhotoEditor
//

import Foundation

struct IdentifiableItem<T>: Identifiable {
    let id = UUID()
    let value: T
}
