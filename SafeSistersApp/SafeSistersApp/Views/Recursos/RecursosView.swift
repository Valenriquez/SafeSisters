//
//  RecursosView.swift
//  SafeSistersApp
//
//  Created by Sofía Cantú on 21/10/24.
//

import SwiftUI

struct RecursosView: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Prevención Section
                    Section(header: HStack {
                        Text("Prevención")
                            .font(.headline)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding(.horizontal)) {
                        Button(action: {
                            path.append("PreventionView")
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(LinearGradient(gradient: Gradient(colors: [Color(red: 0.729, green: 0.149, blue: 0.584), .purple]), startPoint: .top, endPoint: .bottom))
                                    .frame(height: 120)
                                VStack {
                                    Image(systemName: "person.3.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.white)
                                    Text("Safety")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Reportes Anonimos Section
                    Section(header: HStack {
                        Text("Reportes anonimos")
                            .font(.headline)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding(.horizontal)) {
                        HStack {
                            Button(action: {
                                // Acción del botón de Reporte Anónimo
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(red: 0.729, green: 0.149, blue: 0.584))
                                        .frame(height: 120)
                                    Text("Registra un reporte anonimo")
                                        .foregroundColor(.white)
                                        .bold()
                                }
                            }
                            Button(action: {
                                // Acción del botón de otra opción
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.purple)
                                        .frame(height: 120)
                                    Image(systemName: "folder.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Mi Círculo Section
                    Section(header: HStack {
                        Text("Mi círculo")
                            .font(.headline)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding(.horizontal)) {
                        Button(action: {
                            // Acción del botón Mi Círculo
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(red: 0.765, green: 0.153, blue: 0.376))
                                    .frame(height: 120)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                }
                .padding(.top)
                .navigationDestination(for: String.self) { value in
                    if value == "PreventionView" {
                        PreventionView()
                    }
                }
            }
            .navigationTitle("Recursos")
        }///NS
    }
}

/*
struct RecursosView_Previews: PreviewProvider {
    static var previews: some View {
        RecursosView()
    }
}
*/

#Preview {
    RecursosView()
}
