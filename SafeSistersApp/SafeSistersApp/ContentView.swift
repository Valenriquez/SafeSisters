import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color(red: 0.8, green: 0.2, blue: 0.4) // Deep pink background
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                ZStack {
                    Text("SISTER")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(.purple)
                    
                    Text("SAFE")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                        .offset(y: 20)
                }
                
                Text("Tu círculo de confianza a tu alcance")
                    .foregroundColor(.white)
                    .padding(.top, 5)
                
                Spacer()
                
                Button(action: {
                    // Handle Apple sign in
                }) {
                    HStack {
                        Image(systemName: "apple.logo")
                        Text("Sign in with Apple")
                    }
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                
                Button("Tengo un código") {
                    // Handle code entry
                }
                .foregroundColor(.white)
                .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
