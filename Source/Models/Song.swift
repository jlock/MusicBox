//
//  Song.swift
//  Music Box (iOS)
//
//  Created by James Lockhart on 2022-10-30.
//

import Foundation
import SwiftUI

struct Song: Identifiable, Equatable {
    struct Style {
        let color: Color
        let image: String
        
        static let `default` = Style(color: .gray, image: "")
    }
    
    var id: String {
        title
    }
    
    let title: String
    let artist: String
    let fileUrl: URL
    
    var style: Style {
        switch artist {
        case "OnePiece": return Style(color: .yellow, image: "OnePiece")
        default:
            //print("No style implemented for \(artist). Add in Song.swift for custom styling")
            return Style.default
        }
    }
    
    // Our songs should alwas be Artist_Title.mp3
    init(url: URL) {
        self.fileUrl = url
        
        let filenameParts = url
            .relativeString
            .replacingOccurrences(of: ".mp3", with: "")
            .replacingOccurrences(of: "%20", with: " ")
            .split(separator: "_")
        
        guard filenameParts.indices.count == 2 else {
            preconditionFailure("invalid file name. Must be formatted like: Artist_Title.mp3")
        }
        
        self.artist = String(filenameParts[0])
        self.title = String(filenameParts[1])
    }
}
