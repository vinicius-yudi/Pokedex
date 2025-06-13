//
//  ViewModel.swift
//  Pokedex
//
//  Created by user277066 on 6/12/25.
//

import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    private let pokemonManager = PokemonManager()
    
    @Published var pokemonList = [Pokemon]()
    @Published var pokemonDetails: DetailPokemon?
    @Published var searchText = ""
    
    // Used with searchText to filter pokemon results
    var filteredPokemon: [Pokemon] {
        return searchText == "" ? pokemonList : pokemonList.filter { $0.name.contains(searchText.lowercased()) }
    }
    
    init() {
        // CORREÇÃO: Adicionar closures de completion e failure na chamada de getPokemon()
        pokemonManager.getPokemon { [weak self] pokemons in
            DispatchQueue.main.async {
                self?.pokemonList = pokemons
            }
        } failure: { error in
            // Tratamento de erro: imprimir o erro, e você pode adicionar lógica para mostrar um alerta na UI
            print("Erro ao carregar lista de Pokémon: \(error.localizedDescription)")
        }
    }
    
    
    // Get the index of a pokemon ( index + 1 = pokemon id)
    func getPokemonIndex(pokemon: Pokemon) -> Int {
        if let index = self.pokemonList.firstIndex(of: pokemon) {
            return index + 1
        }
        return 0
    }
    
    // Get specific details for a pokemon
    func getDetails(pokemon: Pokemon) {
        let id = getPokemonIndex(pokemon: pokemon)
        
        self.pokemonDetails = nil // Limpa detalhes antigos enquanto carrega novos
        
        pokemonManager.getDetailedPokemon(id: id) { data in
            DispatchQueue.main.async {
                self.pokemonDetails = data
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

    // NOVA FUNÇÃO: Obtém os nomes dos tipos do Pokémon
    func getPokemonTypes(pokemon: DetailPokemon) -> String {
        pokemon.types.map { $0.type.name.capitalized }.joined(separator: ", ")
    }

    // NOVA FUNÇÃO: Obtém os nomes das habilidades do Pokémon
    func getPokemonAbilities(pokemon: DetailPokemon) -> String {
        pokemon.abilities.map { $0.ability.name.capitalized }.joined(separator: ", ")
    }

    // NOVA FUNÇÃO: Obtém os status base do Pokémon formatados
    func getPokemonStats(pokemon: DetailPokemon) -> String {
        pokemon.stats.map { stat in
            "\(stat.stat.name.capitalized): \(stat.baseStat)"
        }.joined(separator: "\n")
    }
}
