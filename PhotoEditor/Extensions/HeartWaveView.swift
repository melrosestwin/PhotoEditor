//
//  HeartWaveView.swift
//  Pillinko
//

import SwiftUI

struct WaveShape: Shape {
    var percentage: CGFloat
    var waveOffset: CGFloat

    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(percentage, waveOffset) }
        set {
            percentage = newValue.first
            waveOffset = newValue.second
        }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let waveHeight: CGFloat = 5.flexible()
        let yOffset = rect.height * (1 - percentage)

        if percentage == 0 {
            return path
        }

        path.move(to: CGPoint(x: 0, y: yOffset))
        for x in stride(from: 0, to: rect.width, by: 1) {
            let relativeX = x / rect.width
            let y = waveHeight * sin((relativeX + waveOffset) * 2 * .pi) + yOffset
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()

        return path
    }
}

struct HeartWaveView: View {
    let percentage: CGFloat
    @State private var animatedPercentage: CGFloat = 0
    @State private var waveOffset: CGFloat = 0

    @State private var timer: Timer?

    var body: some View {
        GeometryReader { geometry in
            if animatedPercentage > 0 {
                WaveShape(percentage: animatedPercentage, waveOffset: waveOffset)
                    .fill(LinearGradient(
                        colors: [.red, .pink],
                        startPoint: .top,
                        endPoint: .bottom
                    ))
            }
        }
        .clipped()
        .onAppear {
            timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                waveOffset += 0.05
                if waveOffset > 1 { waveOffset = 0 }
            }

            withAnimation(.easeInOut(duration: 0.5)) {
                animatedPercentage = percentage
            }
        }
        .onChange(of: percentage) { newPercentage in
            withAnimation(.easeInOut(duration: 0.5)) {
                animatedPercentage = newPercentage
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
}
