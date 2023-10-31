//
//  CharacterDetailView.swift
//  RMapi
//
//  Created by N S on 31.10.2023.
//

import SwiftUI

struct CharacterDetailView: View {
    let character: Character
    @Binding var path: NavigationPath
    var body: some View {
        VStack {
            Text(character.location.name)
                .font(.title)
                .padding()
            
            NavigationLink(destination: EpisodeListView()) {
                Text("Back to Episodes")
            }
        }
    }
}
