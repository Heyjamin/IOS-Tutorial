//
//  MusicControlOverlay.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-08.
//

import SwiftUI

struct GameHUDBar: View {
    var guideMode: GameMode? = nil
    
    @ObservedObject private var audio = AudioManager.shared
    
    var body: some View {
        HStack(spacing: 12){
            if let guideMode {
                GameGuideButton(mode: guideMode)
            }
            
            Spacer(minLength: 0)
            
            audioMenuButton
        }
    }
    
    private var audioMenuButton: some View{
        Menu{
            Toggle(isOn: musicBinding){
                Label("Background Music", systemImage: "music.note")
            }
            
            Toggle(isOn: sfxBinding){
                Label("sound Effects", systemImage: "speaker.wave.2")
            }
        } label: {
            Image(systemName: audioStatusIcon)
                .font(.system(size:15, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 36, height: 36)
                .background(
                    Circle()
                        .fill(Color.white.opacity(0.12))
                        .overlay(Circle().stroke(Color.white.opacity(0.2),lineWidth: 1))
                )
        }
        .menuStyle(.button)
        .buttonStyle(.plain)
        .accessibilityLabel("Sound settings")
        
    }
    
    private var musicBinding: Binding<Bool>{
        Binding(
            get: {audio.musicEnabled},
            set: {audio.musicEnabled = $0}
        )
    }
    
    private var sfxBinding: Binding<Bool>{
        Binding(
            get: {audio.sfxEnabled},
            set: {newValue in
                audio.sfxEnabled = newValue
                if newValue{
                    audio.playSFX(.button)
                }
            }
        )
                
    }
    
    private var audioStatusIcon: String{
        switch (audio.musicEnabled, audio.sfxEnabled){
        case(true,true): return "speaker.wave.2.fill"
        case(true,false): return "speaker.fill"
        case(false,true): return "music.note"
        default: return "speaker.slash.fill"
        }
    }
}

extension View{
    func gameAudioControls(guide mode: GameMode? = nil) -> some View{
        safeAreaInset(edge: .top, spacing: 0) {
            GameHUDBar(guideMode: mode)
                .padding(.horizontal, 16)
                .padding(.top, 4)
                .padding(.bottom, 8)
        }
    }
}

#Preview {
    ZStack{
        Color.black.ignoresSafeArea()
        VStack{
            Text("⚡ TAP FRENZY")
                .font(.title.bold())
                .foregroundColor(.white)
            Spacer()
        }
    }
    .gameAudioControls(guide: .tapFrenzy)
}
