//
//  ContentView.swift
//  RMapi
//
//  Created by N S on 31.10.2023.
//
import SwiftUI
struct Episode: Codable, Identifiable {
    let id: Int
    let name: String
    let characters: [String]
}

struct Character: Codable, Identifiable {
    let id: Int
    let name: String
    let image: String
    let origin, location: Location
}

struct Location: Codable {
    let name: String
    let url: String
}


struct EpisodeListView: View {
    @State private var episodes: [Episode] = []

    var body: some View {
        NavigationView {
            List(episodes) { episode in
                NavigationLink(destination: CharacterListView(episodeId: episode.id)) {
                    Text(episode.name)
                }
            }
            .navigationTitle("Episodes")
        }
        .onAppear() {
            loadEpisodes()
        }
    }
    
    func loadEpisodes() {
        guard let url = URL(string: "https://rickandmortyapi.com/api/episode") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                let decoder = JSONDecoder()
                if let response = try? decoder.decode(APIResponse<[Episode]>.self, from: data) {
                    DispatchQueue.main.async {
                        self.episodes = response.results
                    }
                }
            }
        }
        .resume()
    }
}

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

struct CharacterDetailView: View {
    let character: Character
    
    var body: some View {
        VStack {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .foregroundColor(.gray)
            Text(character.location.name)
                .font(.title)
                .padding()
        }
    }
}

struct ContentView: View {
    var body: some View {
        EpisodeListView()
    }
}

struct APIResponse<T: Codable>: Codable {
    let results: T
}

