//
//  Athlete.swift
//  PhotoEditor
//

import SwiftUI

enum Athlete: Int, CaseIterable {
    case soccer
    case boxing
    case baseball
    
    var title: String {
        switch self {
        case .soccer: "SOCCER"
        case .boxing: "BOXING"
        case .baseball: "BASEBALL"
        }
    }
    
    var icon: ImageResource {
        switch self {
        case .soccer: .soccerAthlete
        case .boxing: .boxingAthlete
        case .baseball: .baseballAthlete
        }
    }
}
