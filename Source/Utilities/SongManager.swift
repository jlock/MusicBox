//
//  SongManager.swift
//  Music Box (iOS)
//
//  Created by James Lockhart on 2022-10-30.
//

import Foundation

struct SongManager {
    typealias FetchHandler = ([Album]) -> Void
    
    func fetch(completion: FetchHandler) {
        guard let urls = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil) else {
            print("Could not load song paths")
            return completion([])
        }
        
        guard !urls.isEmpty else {
            print("No songs found")
            return completion([])
        }
           
        
        let songs = urls.map { url in
            Song(url: url)
        }
        
        var groupedSongs: [String: [Song]] = [:]
        
        for song in songs {
            if groupedSongs[song.artist] == nil { groupedSongs[song.artist] = [] }
            groupedSongs[song.artist]!.append(song)
        }
        
        var albums = groupedSongs.map { artist, songs in
            Album(artist: artist, songs: songs)
        }
        
        albums.sort()
        
        completion(albums)
    }
}
