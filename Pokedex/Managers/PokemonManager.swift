// Pokedex/Managers/PokemonManager.swift
import Foundation

class PokemonManager {
    // Adicione um limite e offset padrão para a paginação
    func getPokemon(limit: Int = 20, offset: Int = 0, completion: @escaping ([Pokemon]) -> (), failure: @escaping (Error) -> ()) { // MODIFICADO
        let urlString = "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)" // MODIFICADO

        Bundle.main.fetchData(url: urlString, model: PokemonPage.self) { pokemonPage in
            completion(pokemonPage.results)
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
