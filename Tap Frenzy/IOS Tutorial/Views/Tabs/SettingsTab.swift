//
//  SettingsTab.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-10.
//

import SwiftUI

struct SettingsTab: View {
    @ObservedObject private var audio = AudioManager.shared
    @ObservedObject private var challenges = DailyChallengeManager.shared
    
    @AppStorage(Const.txtCurrentPlayer)
    private var playerName = ""
    
    @AppStorage(Const.txtDailyChallengeEnabled)
    private var dailyChallengeEnabled = false
    
    @AppStorage(Const.txtDailyChallengeHour)
    private var dailyChallengeHour = 9
    
    @AppStorage(Const.txtDailyChallengeMinutes)
    private var dailyChallengeMinute = 0
    
    @State private var challengeTime = Date()
    @State private var showResetConifrmation = false
    @State private var showResetChallengesConfirmation = false
    @State private var showResetLevelsConfirmation = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                NeonAnimatedBackground(style: .calm)
                
                Form{
                    Section(Const.txtAudio){
                        Toggle(Const.txtSoundEffects, isOn: $audio.sfxEnabled)
                            .onChange(of: audio.sfxEnabled) { _, enabled in
                                if enabled {audio.playSFX(.button)}
                            }
                        Toggle(Const.txtBackgroundMusic, isOn: $audio.musicEnabled)
                            .onChange(of: audio.musicEnabled) { _, enabled in
                                if enabled {audio.playMusic(.menu)}
                            }
                        
                        VStack(alignment: .leading, spacing: 8){
                            HStack{
                                Image(systemName: Const.speakerFillIcon)
                                    .foregroundColor(.neonBlue)
                                Text(Const.txtVolumeSetting)
                                Spacer()
                                Text("\(Int(audio.volume * 100))%")
                                    .foregroundColor(.secondary)
                                    .monospacedDigit()
                            }
                            
                            Slider(value: $audio.volume, in: 0...1, step: 0.05)
                                .tint(.neonPurple)
                                .onChange(of: audio.volume) { _, _ in
                                    audio.playSFX(.button)
                                }
                        }
                    }
                    
                    Section(Const.txtPlayer){
                        HStack{
                            Text(Const.txtCurrentPlayerName)
                            Spacer()
                            Text(playerName.isEmpty ? "-" : playerName)
                                .foregroundColor(.secondary)
                        }
                        
                        Button (Const.txtChangePlayer, role: .destructive){
                            audio.playSFX(.button)
                            playerName = ""
                            PlayerManager.shared.savePlayer("")
                        }
                    }
                    
                    Section(Const.txtDailyChallenge){
                        HStack{
                            Text(Const.txtMasterStreak)
                            Spacer()
                            Label("\(challenges.masterStreak) " + Const.txtDays, systemImage: Const.flameFillIcon)
                                .foregroundColor(.orange)
                        }
                        
                        Button(Const.txtResetDailyChallenges, role: .destructive){
                            audio.playSFX(.button)
                            showResetChallengesConfirmation = true
                        }
                        
                        Toggle(Const.txtEnableNotifications, isOn: $dailyChallengeEnabled)
                            .onChange(of: dailyChallengeEnabled) { _, enabled in
                                audio.playSFX(.button)
                                Task { await updateNotifcations(enabled: enabled)}
                            }
                        
                        DatePicker(
                            Const.txtChallengeTime,
                            selection: $challengeTime,
                            displayedComponents: .hourAndMinute
                        )
                        .disabled(!dailyChallengeEnabled)
                        .onChange(of: challengeTime) {_, newValue in
                            let components = Calendar.current.dateComponents([.hour, .minute], from: newValue)
                            dailyChallengeHour = components.hour ?? 9
                            dailyChallengeMinute = components.minute ?? 0
                            if dailyChallengeEnabled {
                                scheduleNotification()
                            }
                        }
                    }
                    
                    Section(Const.txtData){
                        Button(Const.txtResetAllStats, role: .destructive){
                            audio.playSFX(.button)
                            showResetConifrmation = true
                        }
                        
                        Button(Const.txtResetLevelProg, role: .destructive){
                            audio.playSFX(.button)
                            showResetLevelsConfirmation = true
                        }
                    }
                    
                    Section(Const.txtAbout){
                        HStack(spacing: 12){
                            Image(systemName: Const.gameControllerIcon)
                                .font(.title2)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors:[.neonBlue, .neonPurple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                        )
                                    )
                            VStack(alignment: .leading, spacing: 2){
                                Text(Const.txtNeonArcade.capitalized)
                                    .font(.headline)
                                Text(Const.txtGameDescription)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                        
                        HStack{
                            Text(Const.txtVersion)
                            Spacer()
                            Text(appVersionLabel)
                                .foregroundColor(.secondary)
                                .monospacedDigit()
                        }
                        
                        VStack(alignment: .leading, spacing: 6){
                            Text(Const.txtCreatedBy)
                                .font(.subheadline.weight(.semibold))
                            
                            Text(Const.txtIndexNo)
                                .font(.caption)
                                .foregroundColor(.neonBlue)
                            
                            Text(Const.txtStudentModule)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                        
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle(Const.txtSettings)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                AudioManager.shared.playMusic(.menu)
                challenges.refreshForToday()
                challengeTime = Calendar.current.date(
                    from:DateComponents(hour: dailyChallengeHour, minute: dailyChallengeMinute)
                ) ?? Date()
            }
            .confirmationDialog(
                Const.txtResetStatConf,
                isPresented: $showResetConifrmation,
                titleVisibility: .visible
            ){
                Button(Const.txtResetAllStats, role: .destructive){
                    SessionStore.shared.clearAll()
                    }
                Button(Const.txtCancel, role: .cancel){}
            } message: {
                Text(Const.txtPermenetDeletConfMsg)
            }
            .confirmationDialog(
                Const.txtResetDailyChallengeConf,
                isPresented: $showResetChallengesConfirmation,
                titleVisibility: .visible
            ){
                Button(Const.txtResetChallenges, role: .destructive){
                    challenges.resetAllChallenges()
                }
                Button(Const.txtCancel, role: .cancel){}
            } message: {
                Text(Const.txtResetStreakResetConfMsg)
            }
            .confirmationDialog(
                Const.txtResetAllLevelProgConf,
                isPresented: $showResetLevelsConfirmation,
                titleVisibility: .visible
            ){
                Button(Const.txtResetLevels, role: .destructive){
                    LevelProgressStore.shared.resetAll()
                }
                Button(Const.txtCancel, role: .cancel){}
            } message: {
                Text(Const.txtResetLevelConfMsg)
            }
        }
    }
    
    private func updateNotifcations(enabled: Bool) async {
        if enabled {
            let granted = await NotificationService.shared.requestPermission()
            if granted {
                scheduleNotification()
            }else {
                dailyChallengeEnabled = false
            }
        }else{
            NotificationService.shared.cancelAll()
        }
    }
    
    private func scheduleNotification() {
        NotificationService.shared.scheduleDaily(
            hour: dailyChallengeHour,
            minute: dailyChallengeMinute
            )
    }
    
    private var appVersionLabel: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
}

#Preview{
    SettingsTab()
}
