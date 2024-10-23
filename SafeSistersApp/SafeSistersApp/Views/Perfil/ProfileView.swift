//
//  ProfileView.swift
//  SafeSistersApp
//
//  Created by Sofía Cantú on 21/10/24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                Color(red: 0.765, green: 0.153, blue: 0.376) // #c32760
                    .ignoresSafeArea()
                
                VStack {
                    // Color superior
                    /*
                    Color(red: 0.765, green: 0.153, blue: 0.376)
                        .frame(height: 250)
                        .edgesIgnoringSafeArea(.top)
                        .padding(.top, 0)
                    
                    */
                    Spacer()
                    Color(red: 0.949, green: 0.949, blue: 0.969) // #f2f2f7
                        .frame(height: geometry.size.height * 0.2)
                        .edgesIgnoringSafeArea(.top)
                        .padding(.top, geometry.size.height * 0.15)
                    
                    // Imagen circular
                    Image("FotoPersona1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 10)
                        .offset(y: -(geometry.size.height * 0.31))
                        .padding(.bottom, -(geometry.size.height * 0.3))
                    
                    // Nombre
                    Text("Claudia Tobias")
                        .font(.title)
                        .fontWeight(.medium)
                        .offset(y: -(geometry.size.height * 0.1))
                        //.padding(.top, 20)
                    
                    // Información en la lista
                    List {
                        HStack {
                            Text("Medical Information")
                            Spacer()
                            Text("Detail")
                                .foregroundColor(.gray)
                        }
                        
                        HStack {
                            Text("Title")
                            Spacer()
                            Text("Detail")
                                .foregroundColor(.gray)
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .offset(y: -(geometry.size.height * 0.132))
                    .padding(.bottom, -(geometry.size.height * 0.2))
                    Spacer()
                }
                .edgesIgnoringSafeArea(.all)
                .padding(.top, geometry.size.height * 0.13)
            } /// Zstack
        } ///GR
    }
}


#Preview {
    ProfileView()
}
