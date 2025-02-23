//
//  ProjectCardView.swift
//  PhotoEditor
//

import SwiftUI

struct ProjectCardView: View {
    
    let image: Image
    
    init(image: Image) {
        self.image = image
    }
    
    init(resource: ImageResource) {
        self.image = Image(resource)
    }
    
    var body: some View {
        Color.clear
            .overlay {
                image
                    .resizable()
                    .scaledToFill()
            }
            .clipShape(.rect(cornerRadius: 10.adaptive()))
            .aspectRatio(CGSize(width: 118, height: 148), contentMode: .fit)
            .padding(.vertical, 11.adaptive())
            .padding(.leading, 10.adaptive())
            .padding(.trailing, 13.adaptive())
            .background(Color.black.opacity(0.56))
            .overlay {
                RoundedRectangle(cornerRadius: 14.adaptive())
                    .inset(by: 1.adaptive())
                    .stroke(LinearGradient.yellow, lineWidth: 2.adaptive())
            }
    }
}
