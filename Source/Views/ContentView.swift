//
//  ContentView.swift
//  Shared
//
//  Created by James Lockhart on 2022-10-30.
//

import SwiftUI

struct ContentView: View {
    @StateObject var player = SongPlayer()
    
    private let manager = SongManager()
    @State private var albums: [Album] = []
    
    var body: some View {
        if !albums.isEmpty {
            SongListView(albums: albums, player: player)
        } else {
            ProgressView()
                .task {
                    load()
                }
        }
    }
    
    private func load() {
        manager.fetch { albums in
            self.albums = albums
        }
    }
}
