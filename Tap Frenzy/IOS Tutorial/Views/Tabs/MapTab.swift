//
//  MapTab.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-10.
//

import SwiftUI
import MapKit

struct MapTab: View {
    @State private var sessions: [GameSession] = []
    @State private var selectedSession: GameSession?
    @State private var cameraPosition: MapCameraPosition = .region(MapDefaults.sriLankaRegion)
    
    private var displaySessions: [GameSession] {
        sessions
    }
    
    var body: some View {
        NavigationStack{
            ZStack{
                NeonAnimatedBackground(style: .calm)
                
                VStack(spacing:0){
                    Map(position: $cameraPosition, selection: $selectedSession){
                        ForEach(displaySessions){ session in
                            Marker(
                                "\(session.mode.rawValue): \(session.score)",
                                coordinate: MapDefaults.coordinate(for: session)
                            )
                            .tag(session)
                        }
                    }
                    .mapStyle(.standard(elevation: .realistic))
                    
                    if let session = selectedSession {
                        sessionDetail(session)
                    }else if displaySessions.isEmpty {
                        emptyStateBanner
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear{
                reloadSessions()
                AudioManager.shared.playMusic(.menu)
            }
        }
    }
    
    private var emptyStateBanner: some View {
        HStack(spacing: 12){
            Image(systemName: "mappin.and.ellipse")
                .font(.title2)
                .foregroundColor(.neonBlue)
            VStack(alignment: .leading, spacing: 2){
                Text("Sri Lanka")
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                Text ("Play a game to score pins on the map")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .glassCard()
        .padding()
    }
    
    private func sessionDetail(_ session: GameSession) -> some View {
        let coordinate =============
    }
}

