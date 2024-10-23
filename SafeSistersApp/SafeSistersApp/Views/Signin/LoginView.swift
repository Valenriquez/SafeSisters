//
//  LoginView.swift
//  SafeSistersApp
//
//  Created by Sofía Cantú on 21/10/24.
//
import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    @State private var path = NavigationPath() // Track navigation path
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack(path: $path) {
                ZStack{
                    Color(red: 0.765, green: 0.153, blue: 0.376) // #c32760
                        .ignoresSafeArea()
                    
                    VStack {
                        Spacer()
                        
                        // Título
                        Text("SISTER")
                            .font(.system(size: geometry.size.width * 0.25, weight: .bold))
                            .foregroundColor(Color(red: 0.91, green: 0.549, blue: 0.82)) //#E88CD1
                            .overlay(Text("SAFE")
                                .font(.system(size: geometry.size.width * 0.13, weight: .bold))
                                .foregroundColor(.white)
                                .offset(y: 0))
                            .shadow(color: Color(red: 0.765, green: 0.153, blue: 0.376), radius: 3, x: 0, y: 0) // #c32760
                        
                        // Subtítulo
                        Text("Tu círculo de confianza a tu alcance")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        // Botón de Apple Sign In
                        SignInWithAppleButton(
                            .signIn,
                            onRequest: { request in
                                viewModel.handleSignInWithAppleRequest(request)
                            },
                            onCompletion: { result in
                                viewModel.handleSignInWithAppleCompletion(result)
                            }
                        )
                        .signInWithAppleButtonStyle(.whiteOutline)
                        .frame(width: 280, height: 45)
                        .padding(.bottom, 20)
                        
                        // Botón de "Tengo un código"
                        Button(action: {
                            // Navigate to CodeEntryView
                            path.append("CodeEntry")
                        }) {
                            Text("Tengo un código")
                                .foregroundColor(.white)
                                .font(.headline)
                                .padding(.bottom, 50)
                        }
                    }
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        viewModel.checkIfUserIsSignedIn()
                    }
                } ///ZStack
                // Define navigation destination for CodeEntryView
                .navigationDestination(for: String.self) { value in
                    if value == "CodeEntry" {
                        CodeEntryView()
                    }
                }
            }
        }///GeometryReader
    }
}

#Preview {
    LoginView()
}
