//
//  LocationService.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-10.
//

import CoreLocation
import Combine
import MapKit

enum MapDefaults{
    /// Center of Sri Lanka
    static let sriLankaCenter = CLLocationCoordinate2D(latitude: 7.8731, longitude: 80.7718)
    
    /// Colombo - default pin when device location is unavailable
    static let colombo = CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612)
    
    static var sriLankaRegion: MKCoordinateRegion {
        MKCoordinateRegion(
            center: sriLankaCenter,
            span: MKCoordinateSpan(latitudeDelta: 2.8, longitudeDelta: 2.8)
        )
    }
    
    static func coordinate(for session: GameSession) -> CLLocationCoordinate2D {
        if session.hasValidLocation {
            return CLLocationCoordinate2D(latitude: session.latitude, longitude: session.longitude)
        }
        return colombo
    }
}

@MainActor
final class LocationService: NSObject, ObservableObject{
    static let shared = LocationService()
    
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    private let manager = CLLocationManager()
    
    private override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        authorizationStatus = manager.authorizationStatus
    }
    
    func requestPermission(){
        manager.requestWhenInUseAuthorization()
    }
    
    func startUpdating(){
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            return
        }
        manager.startUpdatingLocation()
    }
    
}

extension LocationService: CLLocationManagerDelegate {
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.last?.coordinate else {
            return
        }
        Task { @MainActor in
            currentLocation = coordinate
        }
    }
    
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            authorizationStatus = manager.authorizationStatus
            if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
                manager.startUpdatingLocation()
            }
        }
    }
    
}

