//
//  PokemonManager.swift
//  Pokedex
//
//  Created by user277066 on 6/12/25.
//

// Pokedex/Managers/PokemonManager.swift
import Foundation

class PokemonManager {
    func getPokemon(completion: @escaping ([Pokemon]) -> (), failure: @escaping (Error) -> ()) {
        let urlString = "https://pokeapi.co/api/v2/pokemon?limit=151"

        Bundle.main.fetchData(url: urlString, model: PokemonPage.self) { pokemonPage in
            completion(pokemonPage.results) // Retorna apenas a lista de Pokémon
        } failure: { error in
            failure(error)
        }
    }
    
    func getDetailedPokemon(id: Int, _ completion:@escaping (DetailPokemon) -> (), failure:@escaping (Error) -> ()) {
        Bundle.main.fetchData(url: "https://pokeapi.co/api/v2/pokemon/\(id)/", model: DetailPokemon.self) { data in
            completion(data)
            print(data)
            
        } failure: { error in
            print(error)
            failure(error) 
        }
    }
}
