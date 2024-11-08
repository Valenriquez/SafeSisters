//
//  MapaView.swift
//  SafeSistersApp
//
//  Created by Sofía Cantú on 21/10/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject var viewModel = MapViewModel(numberOfPeople: 3)
    @StateObject var detailViewModel = PersonDetailViewModel()
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 19.432608, longitude: -99.133209), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    
    var body: some View {
        ZStack {
            // Map with people pins
            Map(coordinateRegion: $region, annotationItems: viewModel.people) { person in
                MapAnnotation(coordinate: person.location) {
                    Circle()
                        .fill(person.color)
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            detailViewModel.selectPerson(person)
                        }
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            // Person detail view when tapped
            if let selectedPerson = detailViewModel.selectedPerson {
                VStack {
                    Spacer()
                    
                    HStack {
                        Image(selectedPerson.image)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(selectedPerson.color, lineWidth: 4))
                        VStack(alignment: .leading) {
                            Text(selectedPerson.name)
                                .font(.headline)
                            Text(selectedPerson.details)
                                .font(.subheadline)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .padding()
                    
                    Button(action: {
                        detailViewModel.selectedPerson = nil
                    }) {
                        Text("Close")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
