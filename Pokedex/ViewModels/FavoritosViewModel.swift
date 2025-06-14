//
//  FavoritosViewModel.swift
//  Pokedex
//
//  Created by user277066 on 6/13/25.
//

import Foundation
import SwiftUI
import SwiftData

class FavoritosViewModel: ObservableObject {
    @Published var favoritos: [Pokemon] = []

    func toggleFavorito(pokemon: Pokemon) {
        if let index = favoritos.firstIndex(where: { $0.id == pokemon.id }) {
            favoritos.remove(at: index)
        } else {
            favoritos.append(pokemon)
        }
    }

    func isFavorito(pokemon: Pokemon) -> Bool {
        favoritos.contains(where: { $0.id == pokemon.id })
    }

}

