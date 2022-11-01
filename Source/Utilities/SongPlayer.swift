//
//  SongPlayer.swift
//  Music Box (iOS)
//
//  Created by James Lockhart on 2022-10-30.
//

import AVFoundation
import SwiftUI

class SongPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    private var player: AVAudioPlayer?
    private var link: CADisplayLink!
    
    @Published var songProgress = 0.0
    var nowPlaying: Song? = nil
    
    private var completion: (() -> Void)?
    
    override init() {
        super.init()
        
        self.link = CADisplayLink(target: self, selector: #selector(update))
        link.add(to: .current, forMode: RunLoop.Mode.default)
    }
    
    deinit {
        link.invalidate()
    }

    func play(_ song: Song, completion: @escaping () -> Void) {
        stop()
        self.completion = completion

        do {
            player = try AVAudioPlayer(contentsOf: song.fileUrl)
            player?.delegate = self
            
            guard let player = player else {
                print("Could not create player for song: \(song.title)")
                return
            }

            player.prepareToPlay()
            player.play()
            
            nowPlaying = song
        } catch {
            print("Error creating player: \(error)")
        }
    }
    
    func stop() {
        player?.stop()
        player = nil
        nowPlaying = nil
        completion = nil
    }
    
    @objc func update() {
        guard let player = player,
              player.isPlaying,
              player.currentTime != 0,
              player.duration != 0 else { return songProgress = 0 }
        
        songProgress = player.currentTime / player.duration
    }
    
    // MARK - AVAudioPlayerDelegate
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        completion?()
    }
}
