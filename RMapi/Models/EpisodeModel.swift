//
//  EpisodeModel.swift
//  RMapi
//
//  Created by N S on 31.10.2023.
//

import Foundation

struct Episode: Codable, Identifiable {
    let id: Int
    let name: String
    let characters: [String]
}
