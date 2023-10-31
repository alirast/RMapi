//
//  LocationViewModel.swift
//  RMapi
//
//  Created by N S on 31.10.2023.
//

import Foundation

struct LocationsResponse: Codable {
    let results: [Location]
}

class LocationsViewModel: ObservableObject {
    @Published var locations = [Location]()
    
    func fetchLocations() {
        guard let url = URL(string: "https://rickandmortyapi.com/api/location") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching locations: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(LocationsResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.locations = response.results
                }
            } catch {
                print("Error decoding locations: \(error.localizedDescription)")
            }
        }.resume()
    }
}
