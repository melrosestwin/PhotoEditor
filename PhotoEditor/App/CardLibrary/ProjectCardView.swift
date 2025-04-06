//
//  ProjectCardView.swift
//  PhotoEditor
//

import SwiftUI

struct ProjectCardView: View {
    
    let image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
    
    init(resource: ImageResource) {
        self.image = UIImage(resource: resource)
    }
    
    var body: some View {
        Color.clear
            .overlay {
                Image(uiImage: image)
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
