//
//  Router.swift
//  SafeSistersApp
//
//  Created by Sofía Cantú on 22/10/24.
//


import Foundation
import SwiftUI

final class Router: ObservableObject {
    
    public enum Destination: Hashable {
        //On boarding Screens
        ///case onboarding
        
        //Main app
        ///case contentView
        ///case mainScreen
        ///case cuentasView
        ///case mapView(expense: Expense)
        
        //Chat screen
        ///case chatView
        ///case chatBotView(chatBot: Int)
        
        //userSettings
        ///case usersettings
        
        //SignIn
        case CodeEnteryView
    }
    
    @Published var navPath = NavigationPath()
    
    func navigate(to destination: Destination) {
        navPath.append(destination)
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}

