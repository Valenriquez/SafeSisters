//
//  SafeSistersAppApp.swift
//  SafeSistersApp
//
//  Created by Valeria Enríquez Limón on 21/10/24.
//

import SwiftUI
import SwiftData

@main
struct SafeSistersAppApp: App {
    
    @StateObject var viewModel = LoginViewModel()
    
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            /*
            if viewModel.isSignedIn {
                ProfileView()
            } else if viewModel.showCodeEntryView {
                CodeEntryView()
            } else {
                LoginView()
            }
            */
            ContentView()
            //LoginView()
        }
        .modelContainer(sharedModelContainer)
    }
}


