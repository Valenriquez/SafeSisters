//
//  PreventionViewModel.swift
//  SafeSistersApp
//
//  Created by Sofía Cantú on 22/10/24.
//

import Foundation

class PreventionViewModel: ObservableObject {
    @Published var items: [PreventionItem] = []
    
    func loadItems() {
        guard let url = Bundle.main.url(forResource: "prevention", withExtension: "json") else {
            print("JSON file not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let items = try decoder.decode([PreventionItem].self, from: data)
            self.items = items
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
}

