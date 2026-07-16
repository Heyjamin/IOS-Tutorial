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
                Label(Const.txtBackgroundMusic, systemImage: Const.musicIcon)
            }
            
            Toggle(isOn: sfxBinding){
                Label(Const.txtSoundEffects, systemImage: Const.speakerIcon)
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
        .accessibilityLabel(Const.txtSoundSettings)
        
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
        case(true,true): return Const.speakerIcon
        case(true,false): return Const.speakerFillIcon
        case(false,true): return Const.musicIcon
        default: return Const.speakerMuteIcon
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
            Text(Const.flash + Const.txtTapFrenzy)
                .font(.title.bold())
                .foregroundColor(.white)
            Spacer()
        }
    }
    .gameAudioControls(guide: .tapFrenzy)
}
