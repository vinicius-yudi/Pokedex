//
//  PokemonDetailViewModel.swift
//  Pokedex
//
//  Created by user277066 on 6/13/25.
//


import Foundation
import SwiftUI // Para @Published

class PokemonDetailViewModel: ObservableObject {
    private let pokemonManager = PokemonManager()
    
    @Published var pokemonDetails: DetailPokemon?
    
    // O Pokemon que está sendo exibido, recebido no init ou via setter
    var pokemon: Pokemon
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
        getDetails() // Carrega os detalhes assim que a ViewModel é criada
    }
    
    // Get specific details for a pokemon
    func getDetails() {
        // Obter o ID do Pokémon da URL do objeto Pokemon
        guard let url = URL(string: pokemon.url),
              let lastPathComponent = url.lastPathComponent,
              let id = Int(lastPathComponent) else {
            print("Não foi possível extrair o ID do Pokémon da URL: \(pokemon.url)")
            return
        }
        
        self.pokemonDetails = nil // Limpa detalhes antigos enquanto carrega novos
        
        pokemonManager.getDetailedPokemon(id: id) { [weak self] data in
            DispatchQueue.main.async {
                self?.pokemonDetails = data
            }
        } failure: { error in
            print(error.localizedDescription) // Tratamento de erro para detalhes
        }
    }
    
    // Formats the Height or the Weight of a given pokemon
    func formatHW(value: Int) -> String {
        let dValue = Double(value)
        let string = String(format: "%.2f", dValue / 10)
        return string
    }

    // Obtém os nomes dos tipos do Pokémon
    func getPokemonTypes(pokemon: DetailPokemon) -> String {
        pokemon.types.map { $0.type.name.capitalized }.joined(separator: ", ")
    }

    // Obtém os nomes das habilidades do Pokémon
    func getPokemonAbilities(pokemon: DetailPokemon) -> String {
        pokemon.abilities.map { $0.ability.name.capitalized }.joined(separator: ", ")
    }

    // Obtém os status base do Pokémon formatados
    func getPokemonStats(pokemon: DetailPokemon) -> String {
        pokemon.stats.map { stat in
            "\(stat.stat.name.capitalized): \(stat.baseStat)"
        }.joined(separator: "\n")
    }
}
