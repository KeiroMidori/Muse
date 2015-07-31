//
//  AudioPlayerManager.swift
//  Muse
//
//  Created by Sacha BECOURT on 7/30/15.
//  Copyright (c) 2015 SB. All rights reserved.
//

import Foundation
import AVFoundation

private let _singletonInstance = AudioPlayerManager()
private var audioPlayer = AVPlayer()
private var track: Track?
class AudioPlayerManager {
    class var sharedInstance: AudioPlayerManager {
        return _singletonInstance
    }
    
    func playWithTrack(trackToPlay: Track) {
        track = trackToPlay
        var urlTmp = trackToPlay.trackURL.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: nil, range: nil)
        println(urlTmp)
        let url = NSURL(string: urlTmp)
        if (url != nil) {
            audioPlayer = AVPlayer(URL: url!)
            audioPlayer.play()
        }
    }
    
    func getPlaybackTime() -> CMTime {
        return audioPlayer.currentTime()
    }
    
    func isTrackPlaying() -> Bool {
        if (audioPlayer.rate > 0.0) {
            return true
        }
        return false
    }
    
    func setPlayerVolume(volume: Float) {
        audioPlayer.volume = volume
    }
    
    func pausePlayer() {
        audioPlayer.pause()
    }
    
    func playPlayer() {
        audioPlayer.play()
    }
    
    func getPlayingTrack() -> Track {
        return track!
    }
}