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
    
    @AppStorage("currentPlayer")
    private var playerName = ""
    
    @AppStorage("dailyChallengeEnabled")
    private var dailyChallengeEnabled = false
    
    @AppStorage("dailyChallengeHour")
    private var dailyChallengeHour = 9
    
    @AppStorage("dailyChallengeMinutes")
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
                    Section("Audio"){
                        Toggle("Sound Effects", isOn: $audio.sfxEnabled)
                            .onChange(of: audio.sfxEnabled) { _, enabled in
                                if enabled {audio.playSFX(.button)}
                            }
                        Toggle("Background Music", isOn: $audio.musicEnabled)
                            .onChange(of: audio.musicEnabled) { _, enabled in
                                if enabled {audio.playMusic(.menu)}
                            }
                        
                        VStack(alignment: .leading, spacing: 8){
                            HStack{
                                Image(systemName: "speaker.fill")
                                    .foregroundColor(.neonBlue)
                                Text("Volume")
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
                    
                    Section("Player"){
                        HStack{
                            Text("Current Player")
                            Spacer()
                            Text(playerName.isEmpty ? "-" : playerName)
                                .foregroundColor(.secondary)
                        }
                        
                        Button ("Change Player", role: .destructive){
                            audio.playSFX(.button)
                            playerName = ""
                            PlayerManager.shared.savePlayer("")
                        }
                    }
                    
                    Section("Daily Challenge"){
                        HStack{
                            Text("master Streak")
                            Spacer()
                            Label("\(challenges.masterStreak) days", systemImage: "flame.fill")
                                .foregroundColor(.orange)
                        }
                        
                        Button("Reset Daily Challenges", role: .destructive){
                            audio.playSFX(.button)
                            showResetChallengesConfirmation = true
                        }
                        
                        Toggle("Enable Notifications", isOn: $dailyChallengeEnabled)
                            .onChange(of: dailyChallengeEnabled) { _, enabled in
                                audio.playSFX(.button)
                                Task { await updateNotifcations(enabled: enabled)}
                            }
                        
                        DatePicker(
                            "Challenge Time",
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
                    
                    Section("Data"){
                        Button("Reset All Stats", role: .destructive){
                            audio.playSFX(.button)
                            showResetConifrmation = true
                        }
                        
                        Button("Reset Level Progress", role: .destructive){
                            audio.playSFX(.button)
                            showResetLevelsConfirmation = true
                        }
                    }
                    
                    Section("About"){
                        HStack(spacing: 12){
                            Image(systemName: "gamecontroller.fill")
                                .font(.title2)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors:[.neonBlue, .neonPurple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                        )
                                    )
                            VStack(alignment: .leading, spacing: 2){
                                Text("Nen Arcade")
                                    .font(.headline)
                                Text("Tap Frenzy Mini-Game Collection")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                        
                        HStack{
                            Text("Version")
                            Spacer()
                            Text(appVersionLabel)
                                .foregroundColor(.secondary)
                                .monospacedDigit()
                        }
                        
                        VStack(alignment: .leading, spacing: 6){
                            Text("Created by Nuwan Jeewantha")
                                .font(.subheadline.weight(.semibold))
                            
                            Text("COBSCCOMP251P-045")
                                .font(.caption)
                                .foregroundColor(.neonBlue)
                            
                            Text("Student - NIBM iOS Module")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                        
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                AudioManager.shared.playMusic(.menu)
                challenges.refreshForToday()
                challengeTime = Calendar.current.date(
                    from:DateComponents(hour: dailyChallengeHour, minute: dailyChallengeMinute)
                ) ?? Date()
            }
            .confirmationDialog(
                "Reset all game stats?",
                isPresented: $showResetConifrmation,
                titleVisibility: .visible
            ){
                Button("Reset All Stats", role: .destructive){
                    SessionStore.shared.clearAll()
                    }
                Button("Cancel", role: .cancel){}
            } message: {
                Text("This permenetly deletes all saved game sessions.")
            }
            .confirmationDialog(
                "Reset daily challenges?",
                isPresented: $showResetChallengesConfirmation,
                titleVisibility: .visible
            ){
                Button("Reset Challenges", role: .destructive){
                    challenges.resetAllChallenges()
                }
                Button("Cancel", role: .cancel){}
            } message: {
                Text("All streaks and today's progress will restart from zero.")
            }
            .confirmationDialog(
                "Reset all level progress?",
                isPresented: $showResetLevelsConfirmation,
                titleVisibility: .visible
            ){
                Button("Reset Levels", role: .destructive){
                    LevelProgressStore.shared.resetAll()
                }
                Button("Cancel", role: .cancel){}
            } message: {
                Text("All level stars and unlocks will be reset. Level 1 stays open.")
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
