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
                            .contentShape(Rectangle())
                            .onTapGesture {
                                player.toggle(song: song)
                            }
                    }
                }
            }
        }
        .listStyle(.grouped)
    }
}
