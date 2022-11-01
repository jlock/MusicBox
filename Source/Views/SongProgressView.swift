//
//  SongProgressView.swift
//  Music Box (iOS)
//
//  Created by James Lockhart on 2022-10-31.
//

import SwiftUI
import CoreGraphics
import Foundation

struct SongProgressView: View {
    @ObservedObject var player: SongPlayer
    
    private let progressHeight = CGFloat(2)
    private let offset = CGSize(width: 20, height: 5)
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let minWidth = CGFloat(-offset.width)
                let maxWidth = geometry.size.width + (offset.width * 2)
                let progressWidth = maxWidth * player.songProgress - offset.width
                
                let minHeight = geometry.size.height - progressHeight + offset.height
                let maxHeight = geometry.size.height + offset.height
                
                path.move(to: CGPoint(x: minWidth, y: minHeight))

                let points = [
                    CGPoint(x: progressWidth, y: minHeight),
                    CGPoint(x: progressWidth, y: maxHeight),
                    CGPoint(x: minWidth, y: maxHeight)
                ]
                
                points.forEach { path.addLine(to: $0) }
                path.closeSubpath()
            }
            .fill(.blue)
        }
    }
}
