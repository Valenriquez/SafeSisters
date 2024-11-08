//
//  ContentView.swift
//  SafeSistersApp
//
//  Created by Sofía Cantú on 21/10/24.
//
import SwiftUI

struct ContentView: View {
    @AppStorage("isSignInCompleted") var isSignInCompleted: Bool = false
    //@AppStorage("isSignInCompleted") var isSignInCompleted: Bool = true


    init() {
        // Customize Tab Bar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white // Set Tab Bar background to white
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().backgroundColor = UIColor.white // For iOS 15+ to ensure background is white
        
        // Customize selected tab color
        UITabBar.appearance().tintColor = UIColor(red: 0.765, green: 0.153, blue: 0.376, alpha: 1.0) // Pink color for selected tab
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray // Optional: Gray color for unselected tabs
    }

    var body: some View {
        if isSignInCompleted {
            TabView {
                ProfileView()
                    .tabItem {
                        Label("Perfil", systemImage: "person.fill")
                    }
                
                MapView()
                    .tabItem {
                        Label("Mapa", systemImage: "map.fill")
                    }
                
                ForoView()
                    .tabItem {
                        Label("Foro", systemImage: "bubble")
                    }
                
                RecursosView()
                    .tabItem {
                        Label("Recursos", systemImage: "book.fill")
                    }
                
                MiCirculoView()
                    .tabItem {
                        Label("Mi Círculo", systemImage: "person.3.fill")
                    }
            }
            .accentColor(Color(red: 0.765, green: 0.153, blue: 0.376))
            .navigationBarBackButtonHidden(true)
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
