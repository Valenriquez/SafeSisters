//
//  CodeenteryViewModel.swift
//  SafeSistersApp
//
//  Created by Sofía Cantú on 21/10/24.
//

import SwiftUI

class CodeEntryViewModel: ObservableObject {
    @Published var validCodes: [String] = []
    
    init() {
        loadCodes()
    }
    
    // Cargar los códigos desde el archivo JSON
    private func loadCodes() {
        if let url = Bundle.main.url(forResource: "codes", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let json = try JSONDecoder().decode(Codes.self, from: data)
                self.validCodes = json.codes
            } catch {
                print("Error al cargar los códigos: \(error)")
            }
        }
    }
    
    func validateCode(_ code: String) -> Bool {
        return validCodes.contains(code)
    }
}

struct Codes: Codable {
    let codes: [String]
}

