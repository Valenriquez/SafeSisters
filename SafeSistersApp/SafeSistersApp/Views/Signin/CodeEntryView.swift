//
//  CodeEntryView.swift
//  SafeSistersApp
//
//  Created by Sofía Cantú on 21/10/24.
//

import SwiftUI

struct CodeEntryView: View {
    @Environment(\.dismiss) var dismiss // For dismissing the current view
    @State private var path = NavigationPath() // Track navigation path
    
    @AppStorage("isSignInCompleted") var isSignInCompleted: Bool = false
    @State private var code = ""
    @StateObject var viewModel = CodeEntryViewModel()
    @State private var isValid = false
    @State private var showAlert = false
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack(path: $path) {
                ZStack{
                    Color(red: 0.765, green: 0.153, blue: 0.376) // #c32760
                        .ignoresSafeArea()
                    VStack {
                        // Customized back button
                        HStack{
                            Button(action: {
                                dismiss() // Dismiss the current view
                            }) {
                                Text("Volver")
                                    .foregroundColor(Color(red: 0.765, green: 0.153, blue: 0.376)) // Pink text
                                    .padding()
                                    .frame(width: 120, height: 40)
                                    .background(Color.white) // White background
                                    .cornerRadius(20) // Rounded button
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color(red: 0.765, green: 0.153, blue: 0.376), lineWidth: 2) // Optional pink border
                                    )
                            }
                            .shadow(radius: 5) // Add shadow for visual effect
                            .padding(.top, 50)
                            Spacer()
                        }
                        Spacer()
                        
                        Text("Ingresa tu código")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(.bottom, 20)
                        
                        TextField("Código", text: $code)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal, 20)
                        
                        Button(action: {
                            isValid = viewModel.validateCode(code)
                            showAlert = true
                        }) {
                            Text("Validar Código")
                                .foregroundColor(.white)
                                .font(.headline)
                                .padding()
                                .background(Color(red: 0.91, green: 0.549, blue: 0.82))
                                .cornerRadius(8)
                        }
                        .padding(.top, 20)
                        .alert(isPresented: $showAlert) {
                            if isValid {
                                isSignInCompleted.toggle()
                                path.append("ContentView")
                                return Alert(title: Text("Código Válido"), message: Text("El código es correcto."))
                            } else {
                                return Alert(title: Text("Código Inválido"), message: Text("Por favor, intenta nuevamente."))
                            }
                        }///Button
                        Spacer()
                    }
                    .padding()
                    .padding(.bottom, 150)
                    .edgesIgnoringSafeArea(.all)
                } ///ZStack
            }
        } ///GR
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    CodeEntryView()
}
