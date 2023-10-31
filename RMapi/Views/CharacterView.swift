//
//  CharacterView.swift
//  RMapi
//
//  Created by N S on 31.10.2023.
//

import SwiftUI

struct CharacterListView: View {
    let episodeId: Int
    @State private var characters: [Character] = []
    
    var body: some View {
        List(characters) { character in
            NavigationLink(destination: CharacterDetailView(character: character)) {
                HStack {
                    Image(systemName: "person.crop.circle.fill")
                        .foregroundColor(.gray)
                    Text(character.name)
                }
            }
        }
        .navigationTitle("Characters")
        .onAppear() {
            loadCharacters()
        }
    }
    
    func loadCharacters() {
        guard let url = URL(string: "https://rickandmortyapi.com/api/episode/\(episodeId)") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                let decoder = JSONDecoder()
                if let response = try? decoder.decode(Episode.self, from: data) {
                    var characters: [Character] = []
                    let group = DispatchGroup()
                    for characterURLString in response.characters {
                        if let characterURL = URL(string: characterURLString) {
                            group.enter()
                            URLSession.shared.dataTask(with: characterURL) { data, _, _ in
                                if let data = data {
                                    if let character = try? decoder.decode(Character.self, from: data) {
                                        characters.append(character)
                                    }
                                }
                                group.leave()
                            }
                            .resume()
                        }
                    }
                    group.notify(queue: DispatchQueue.main) {
                        self.characters = characters
                    }
                }
            }
        }
        .resume()
    }
}
