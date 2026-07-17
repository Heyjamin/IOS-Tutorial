//
//  AudioManager.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-09.
//

import AVFoundation
import Combine
import SwiftUI

enum MusicTrack: String, CaseIterable {
    case menu = "menu_theme"
    case tapFrenzy = "tap_frenzy_theme"
    case lightItUp = "light_it_up_theme"
    case quizRush = "quiz_rush_theme"
    
}

enum SoundEffect: String{
    case button = "sfx_button"
    case card = "sfx_card"
    case tap = "sfx_tap"
    case correct = "sfx_correct"
    case wrong = "sfx_wrong"
    case success = "sfx_success"
    case gameOver = "sfx_game_over"
    case bonus = "sfx_bonus"
    case penalty = "sfx_penalty"
}

@MainActor
final class AudioManager: ObservableObject {
    
    static let shared = AudioManager()
    
    @Published var sfxEnabled: Bool{
        didSet {
            UserDefaults.standard.set(sfxEnabled, forKey: Keys.sfxEnabled)
        }
    }
    
    @Published var musicEnabled: Bool{
        didSet {
            UserDefaults.standard.set(musicEnabled, forKey: Keys.musicEnabled)
            if musicEnabled {
                playMusic(currentTrack)
            }else{
                stopMusic()
            }
        }
    }
    
    @Published var volume: Double{
        didSet {
            let clamped = min(max(volume,0),1)
            if clamped != volume {
                volume = clamped; return
            }
            UserDefaults.standard.set(volume, forKey: Keys.volume)
            applyVolume()
        }
    }
    
    private enum Keys {
        static let sfxEnabled = Const.txtSfxEnabled
        static let musicEnabled = Const.txtMusicEnabled
        static let volume = Const.txtVolume
    }
    
    private var musicPlayer: AVAudioPlayer?
    private var currentTrack: MusicTrack = .menu
    
    private init() {
        sfxEnabled = UserDefaults.standard.object(forKey: Keys.sfxEnabled) as? Bool ?? true
        musicEnabled = UserDefaults.standard.object(forKey: Keys.musicEnabled) as? Bool ?? true
        volume = UserDefaults.standard.object(forKey: Keys.volume) as? Double ?? 0.7
        configureSession()
    }
        
    func configureSession(){
        do{
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.ambient, mode: .default, options:[.mixWithOthers])
            try session.setActive(true)
        }catch{
            print(Const.txtAudioError, error)
        }
    }
    
    // Music
    
    func playMusic(_ track: MusicTrack){
        currentTrack = track
        guard musicEnabled else { return }
        
        if musicPlayer?.url?.lastPathComponent == "\(track.rawValue).wav", musicPlayer?.isPlaying == true {
            return
        }
     
        guard let url = Bundle.main.url(forResource: track.rawValue, withExtension: "wav") else{
            print(Const.txtMissingMusicFile, track.rawValue)
            return
        }
        
        do {
            musicPlayer?.stop()
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = -1
            player.volume = Float(volume) * 0.85
            player.prepareToPlay()
            player.play()
            musicPlayer = player
        }catch{
            print(Const.txtMusicPlaybackError, error)
        }
    }
    
    func stopMusic(){
        musicPlayer?.stop()
        musicPlayer = nil
    }
    
    func toggleMusic(){
        musicEnabled.toggle()
        playSFX(.button)
    }
    
    // Sound Effects
    
    func playSFX(_ effect: SoundEffect){
        guard sfxEnabled else { return }
        
        guard let url = Bundle.main.url(forResource: effect.rawValue, withExtension: "wav") else{
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = Float(volume)
            player.prepareToPlay()
            player.play()
        }catch{
            print(Const.txtSfxError, error)
        }
    }
    
    private func applyVolume(){
        musicPlayer?.volume = Float(volume) * 0.85
    }
        
}
