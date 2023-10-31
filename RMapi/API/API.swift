//
//  API.swift
//  RMapi
//
//  Created by N S on 31.10.2023.
//

import Foundation

struct APIResponse<T: Codable>: Codable {
    let results: T
}
