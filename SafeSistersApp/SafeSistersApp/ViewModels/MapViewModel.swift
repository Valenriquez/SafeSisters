//
//  MapViewModel.swift
//  SafeSistersApp
//
//  Created by Sofía Cantú on 22/10/24.
//
import SwiftUI
import MapKit

struct Person: Identifiable {
    let id = UUID()
    let name: String
    let location: CLLocationCoordinate2D
    let color: Color
    let image: String
    let details: String
}

//Nuevo
struct RiskZone: Codable, Identifiable {
    let id: String
    let type: ZoneType
    let coordinates: [ZoneCoordinate]
    
    var color: Color {
        switch type {
        case .high:
            return .red.opacity(0.3)
        case .moderate:
            return .yellow.opacity(0.3)
        case .safe:
            return .green.opacity(0.3)
        case .women:
            return .purple.opacity(0.3)
        }
    }
}

struct ZoneCoordinate: Codable {
    let latitude: Double
    let longitude: Double
}

enum ZoneType: String, Codable {
    case high = "high"
    case moderate = "moderate"
    case safe = "safe"
    case women = "women"
}

class MapViewModel: ObservableObject {
    @Published var people: [Person]
    //Nuevo
    @Published var riskZones: [RiskZone] = []
    @Published var userLocation: CLLocationCoordinate2D?
    private var locationManager: CLLocationManager?
    
    init(numberOfPeople: Int) {
        // Set example people data based on the number (e.g., 3)
        self.people = [
            Person(name: "Anahi Cardenas",
                   location: CLLocationCoordinate2D(latitude: 19.432608, longitude: -99.133209),
                   color: .red,
                   image: "FotoPersona1",
                   details: "Last seen 5:30 PM at Rio Tepeyac"),
            Person(name: "Carla Gomez",
                   location: CLLocationCoordinate2D(latitude: 19.431, longitude: -99.134),
                   color: .orange,
                   image: "FotoPersona2",
                   details: "Near Tepic"),
            Person(name: "Luis Martinez",
                   location: CLLocationCoordinate2D(latitude: 19.430, longitude: -99.132),
                   color: .blue,
                   image: "FotoPersona3",
                   details: "Last seen in Park Esperanza")
        ].prefix(numberOfPeople).map { $0 }
        
        //Nuevo
        /*
        super.init()
        setupLocationManager()
        loadZones()
        */
    }
}

class PersonDetailViewModel: ObservableObject {
    @Published var selectedPerson: Person? = nil
    
    func selectPerson(_ person: Person) {
        self.selectedPerson = person
    }
}
