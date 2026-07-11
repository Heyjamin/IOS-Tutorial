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
        let coordinate = MapDefaults.coordinate(for: session)
        return HStack{
            VStack(alignment: .leading, spacing: 4){
                Text(session.mode.rawValue)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(session.timestamp, style: .date)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(String(format: "%.4f°, %.4f°", coordinate.latitude, coordinate.longitude))
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text("\(session.score) pts")
                .font(.title3.bold())
                .foregroundColor(.neonGreen)
        }
        .padding()
        .glassCard()
        .padding()
    }
    
    private func reloadSessions(){
        sessions = SessionStore.shared.loadSessions()
            .sorted{ $0.timestamp > $1.timestamp}
        
        if displaySessions.isEmpty {
            cameraPosition = .region(MapDefaults.sriLankaRegion)
        }else if displaySessions.count == 1, let session = displaySessions.first {
            let center = MapDefaults.coordinate(for: session)
            cameraPosition = .region(MKCoordinateRegion(
                center: center,
                span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
                ))
        }else{
            cameraPosition = .region(regionFitting(displaySessions))
        }
    }
    
    private func regionFitting(_ sessions: [GameSession]) -> MKCoordinateRegion {
        let coordinates = sessions.map{MapDefaults.coordinate(for: $0)}
        let latitude = coordinates.map(\.latitude)
        let longitude = coordinates.map(\.longitude)
        
        let minLat = latitude.min() ?? MapDefaults.sriLankaCenter.latitude
        let maxLat = latitude.max() ?? MapDefaults.sriLankaCenter.latitude
        let minLon = longitude.min() ?? MapDefaults.sriLankaCenter.longitude
        let maxLon = longitude.max() ?? MapDefaults.sriLankaCenter.longitude
        
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        let latData = max((maxLat - minLat) * 1.4, 0.08)
        let lonData = max((maxLon - minLon) * 1.4, 0.08)
        
        return MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(
                latitudeDelta: min(lonData,2.8),
                longitudeDelta: min(latData, 2.8)
            )
        )
    }
}

#Preview {
    MapTab()
}
