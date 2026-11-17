//
//  LocationService.swift
//  BoulderingApp
//
//  Created by Przemyslaw Idziak on 17/11/2026.
//

import CoreLocation
import Foundation
import MapKit

protocol LocationServicing {
    func fetchCurrentPlaceName() async -> String?
}

final class LocationService: NSObject, LocationServicing, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private var continuation: CheckedContinuation<CLLocation?, Never>?
    
    override init(){
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func fetchCurrentPlaceName() async -> String? {
    func fetchCurrentPlaceName() async -> String? {
        guard let location = await requestSingleLocation(),
              let request = MKReverseGeocodingRequest(location: location) else {return nil}
        
        do {
            let mapItems = try await request.mapItems
            guard let firstItem = mapItems.first else {return nil}
            
            return firstItem.addressRepresentations?.cityName ?? firstItem.address?.shortAddress ?? firstItem.name
        } catch {
            return nil
        }
    }
    
    private func requestSingleLocation() async -> CLLocation? {
        guard continuation == nil else {return nil}
        
        return await withCheckedContinuation {continuation in
            self.continuation = continuation
            
            switch manager.authorizationStatus {
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse, .authorizedAlways:
                manager.requestLocation()
            case .denied, .restricted:
                resumeOnce(with: nil)
            @unknown default:
                resumeOnce(with: nil)
            }
        }
    }
    
    private func resumeOnce(with location: CLLocation?) {
        continuation?.resume(returning: location)
        continuation = nil
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            resumeOnce(with: nil)
        case .notDetermined:
            break
        @unknown default:
            resumeOnce(with: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        resumeOnce(with: locations.first)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        resumeOnce(with: nil)
    }
}
