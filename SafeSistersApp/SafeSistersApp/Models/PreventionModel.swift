//
//  PreventionModel.swift
//  SafeSistersApp
//
//  Created by Sofía Cantú on 22/10/24.
//

import Foundation

struct PreventionItem: Identifiable, Codable {
    //let id = UUID() // Si el JSON no tiene un id, puedes generar uno único.
    let id: String
    let title: String
    let description: String
    let time: String
    let date: String
    let image: String
}

