//
//  LoginViewModel.swift
//  SafeSistersApp
//
//  Created by Sofía Cantú on 21/10/24.
//

import SwiftUI
import AuthenticationServices

class LoginViewModel: NSObject, ObservableObject {
    @Published var isSignedIn = false
    //@Published var showCodeEntryView = false
    //@EnvironmentObject var router: Router
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }
    
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let auth):
            // Aquí puedes manejar el éxito de la autenticación
            self.isSignedIn = true
        case .failure(let error):
            print("Error al iniciar sesión: \(error.localizedDescription)")
        }
    }
    
    func checkIfUserIsSignedIn() {
        // Aquí puedes comprobar si el usuario ya está autenticado
        // Si ya está autenticado, cambia la pantalla.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Simulación de estado autenticado
            self.isSignedIn = true
        }
    }
        
}


