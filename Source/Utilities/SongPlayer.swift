//
//  SongPlayer.swift
//  Music Box (iOS)
//
//  Created by James Lockhart on 2022-10-30.
//

import MediaPlayer
import AVFoundation
import SwiftUI

class SongPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    private var player: AVAudioPlayer?
    private var link: CADisplayLink!
    
    @Published var songProgress = 0.0
    
    var nowPlaying: Song? = nil {
        didSet {
            setupNowPlaying()
        }
    }
    
    var albums: [Album] = []
        
    override init() {
        super.init()
        
        self.link = CADisplayLink(target: self, selector: #selector(update))
        link.add(to: .current, forMode: RunLoop.Mode.default)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
        setupRemoteTransportControls()
    }
    
    deinit {
        link.invalidate()
    }

    func play(_ song: Song) {
        stop()

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
    }
    
    @objc func update() {
        guard let player = player,
              player.isPlaying,
              player.currentTime != 0,
              player.duration != 0 else { return songProgress = 0 }
        
        songProgress = player.currentTime / player.duration
    }
    
    func toggle(song: Song) {
        if nowPlaying == song {
            stop()
        } else {
            play(song)
        }
    }
    
    // MARK - AVAudioPlayerDelegate
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        guard flag, let nextSong = nextSong() else { return }
        
        play(nextSong)
    }
    
    private func nextSong() -> Song? {
        guard let nowPlaying = nowPlaying else { return nil }
        
        return albums.next(after: nowPlaying)
    }
    
    private func previousSong() -> Song? {
        guard let nowPlaying = nowPlaying else { return nil }
        
        return albums.previous(to: nowPlaying)
    }

    
    // MARK - MediaPlayer
    
    func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.pauseCommand.addTarget { [unowned self] event in
            player?.pause()
            return .success
        }
        
        commandCenter.playCommand.addTarget { [unowned self] event in
            player?.play()
            return .success
        }
        
        commandCenter.stopCommand.addTarget { [unowned self] event in
            player?.stop()
            return .success
        }
        
        commandCenter.nextTrackCommand.addTarget { [unowned self] event in
            if let nextSong = nextSong() {
                play(nextSong)
            }
            
            return .success
        }
        
        commandCenter.previousTrackCommand.addTarget { [unowned self] event in
            if let previousSong = previousSong() {
                play(previousSong)
            }
            
            return .success
        }
    }
    
    func setupNowPlaying() {
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = nowPlaying?.title
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player?.currentTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = player?.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player?.rate

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}
