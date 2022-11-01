//
//  Array_Album+Extensions.swift
//  Music Box (iOS)
//
//  Created by James Lockhart on 2022-11-01.
//

import Foundation

extension Array where Element == Album {
    func next(after song: Song) -> Song? {
        guard let albumIndex = firstIndex(where: { $0.artist == song.artist }) else { return nil }
        
        let album = self[albumIndex]
        
        // Next song in album
        if let songIndex = album.songs.firstIndex(of: song) {
           let nextSongIndex = album.songs.index(after: songIndex)
            
            if album.songs.indices.contains(nextSongIndex) {
                return album.songs[nextSongIndex]
            }
        }
        
        // First song in next album
        let nextAlbumIndex = index(after: albumIndex)
        if indices.contains(nextAlbumIndex) {
            return self[nextAlbumIndex].songs.first
        }
        
        // We finished all songs
        return nil
    }
}
