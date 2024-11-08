//
//  PreventionView.swift
//  SafeSistersApp
//
//  Created by Sofía Cantú on 22/10/24.
//


import SwiftUI

struct PreventionView: View {
    @StateObject private var viewModel = PreventionViewModel()
    @Environment(\.dismiss) var dismiss 
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack{
                    VStack{
                        HStack{
                            Button(action: {
                                dismiss() // Dismiss the current view
                            }) {
                                Text("< Regresar")
                                    .foregroundColor(Color(red: 0.765, green: 0.153, blue: 0.376)) // Pink text
                                    //.padding()
                                    .frame(width: 120, height: 40)
                                    .background(Color.white) // White background
                                    .cornerRadius(20) // Rounded button
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color(red: 0.765, green: 0.153, blue: 0.376), lineWidth: 2)
                                    )
                            }
                            //.shadow(radius: 5) // Add shadow for visual effect
                            //.padding(.top, 50)
                            Spacer()
                        }
                        .padding(.leading, 20)
                        
                        Color(red: 0.949, green: 0.949, blue: 0.969) // #f2f2f7
                            .frame(height: geometry.size.height * 0.15)
                            .edgesIgnoringSafeArea(.top)
                            .padding(.top, geometry.size.height * 0.03)
                        
                        Text("Previniendo Juntas")
                            .font(.title)
                            .fontWeight(.medium)
                            .foregroundColor(Color(red: 0.765, green: 0.153, blue: 0.376))
                            .offset(y: -(geometry.size.height * 0.11))
                        
                        ScrollView {
                            VStack(spacing: geometry.size.height * 0.23) {
                                ForEach(viewModel.items) { item in
                                    PreventionCardView(item: item)
                                }
                            }
                            .padding()
                            //.padding(.bottom, geometry.size.height * 0.4)
                        }
                        //.navigationTitle("Previniendo Juntas")
                        .offset(y: -(geometry.size.height * 0.05))
                        .padding(.bottom, -(geometry.size.height * 0.05))
                        .onAppear {
                            viewModel.loadItems()
                        }
                    }
                }///ZS
            }///GR
            //.navigationBarBackButtonHidden(true)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct PreventionCardView: View {
    let item: PreventionItem
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Image(item.image)
                    .resizable()
                    .frame(width: geometry.size.width * 0.3, height: geometry.size.width * 0.3)
                    .padding(.horizontal, geometry.size.width * 0.01)
                
                VStack(alignment: .leading, spacing: geometry.size.height * 1) {
                    Text(item.title)
                        .font(.headline)
                        .lineLimit(nil) // Permitir múltiples líneas
                        .fixedSize(horizontal: false, vertical: true) // Asegurar que el texto se ajuste a varias líneas

                    Text(item.description)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(nil) // Permitir múltiples líneas
                        .fixedSize(horizontal: false, vertical: true) // Asegurar que el texto se ajuste a varias líneas
                    
                    HStack {
                        Text(item.date)
                        Spacer()
                        Text(item.time)
                    }
                    .font(.caption)
                }

                Spacer()
                /*
                Button(action: {
                    // Acción del botón de "Play"
                }) {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.blue)
                }
                */
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .shadow(radius: 5)
        }///GR
    }
}


#Preview {
    PreventionView()
}
