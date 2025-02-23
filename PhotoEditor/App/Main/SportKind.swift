//
//  SportKind.swift
//  PhotoEditor
//

import SwiftUI

enum SportKind: Int, CaseIterable {
    case soccer
    case boxing
    case cricket
    
    var title: String {
        switch self {
        case .soccer: "SOCCER"
        case .boxing: "BOXING"
        case .cricket: "CRICKET"
        }
    }
    
    var athleteIcon: ImageResource {
        switch self {
        case .soccer: .soccerAthlete
        case .boxing: .boxingAthlete
        case .cricket: .cricketAthlete
        }
    }
    
    var backgrounds: [ImageResource] {
        switch self {
        case .soccer: [.soccerBackground1, .soccerBackground2, .soccerBackground3]
        case .boxing: [.boxingBackground1, .boxingBackground2, .boxingBackground3]
        case .cricket: [.cricketBackground1, .cricketBackground2, .cricketBackground3]
        }
    }
    
    var templateImages: [ImageResource] {
        switch self {
        case .soccer: [.soccerTemplate1, .soccerTemplate2, .soccerTemplate3]
        case .boxing: [.boxingTemplate1, .boxingTemplate2, .boxingTemplate3]
        case .cricket: [.cricketTemplate1, .cricketTemplate2, .cricketTemplate3]
        }
    }
}
