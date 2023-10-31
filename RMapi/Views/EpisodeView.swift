//
//  EpisodeView.swift
//  RMapi
//
//  Created by N S on 31.10.2023.
//

import SwiftUI

struct EpisodeListView: View {
    @State private var episodes: [Episode] = []
    //@State private var path = [Episode]()
    @State private var path = NavigationPath()
    var body: some View {
        NavigationStack(path: $path) {
            List(episodes) { episode in
                NavigationLink(destination: CharacterListView(episodeId: episode.id, path: $path)) {
                    Text(episode.name)
                }
            }
            .navigationTitle("Episodes")
        }
        .onAppear() {
            loadEpisodes()
        }
        
        Button(action: {
            print(path)
        }, label: {
            Text("pop to root")
        })
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
