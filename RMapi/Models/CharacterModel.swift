//
//  CharacterModel.swift
//  RMapi
//
//  Created by N S on 31.10.2023.
//

import Foundation

struct Character: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let image: String
    let origin, location: Location
}
