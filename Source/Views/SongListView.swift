//
//  SongListView.swift
//  Music Box (iOS)
//
//  Created by James Lockhart on 2022-10-31.
//

import SwiftUI

struct SongListView: View {
    let albums: [Album]
    @ObservedObject var player: SongPlayer
    
    var body: some View {        
        List {
            ForEach(albums) { album in
                Section(header: Text(album.artist)) {
                    ForEach(album.songs) { song in
                        SongView(song: song, player: player)
                            .onTapGesture {
                                toggle(song: song)
                            }
                    }
                }
            }
        }
        .listStyle(.grouped)
    }
    
    /// Toggle the song on or off if the same song is selected
    /// When a song finishes successfully; pick the next song in the album or the first song in the next album
    private func toggle(song: Song) {
        if player.nowPlaying == song {
            player.stop()
        } else {
            player.play(song) {
                if let nextSong = albums.next(after: song) {
                    toggle(song: nextSong)
                }
            }
        }
    }
}
