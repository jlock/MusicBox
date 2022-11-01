//
//  SongView.swift
//  Music Box (iOS)
//
//  Created by James Lockhart on 2022-10-30.
//

import SwiftUI

struct SongView: View {
    let song: Song
    
    @ObservedObject var player: SongPlayer
    
    var body: some View {
        ZStack {
            HStack(alignment: .top) {
                Text(song.title).font(.headline)
                Spacer()
            }
            
            if song == player.nowPlaying {
                SongProgressView(player: player)
            }
        }
    }
}
