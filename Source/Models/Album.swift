//
//  Album.swift
//  Music Box (iOS)
//
//  Created by James Lockhart on 2022-11-01.
//

import Foundation

struct Album: Identifiable, Comparable {
    static func <(lhs: Album, rhs: Album) -> Bool {
        return lhs.artist < rhs.artist
    }
    
    var id: String {
        artist
    }
    
    let artist: String
    let songs: [Song]
}
