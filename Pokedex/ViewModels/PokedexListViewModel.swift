//
//  PokedexListViewModel.swift
//  Pokedex
//
//  Created by user277066 on 6/13/25.
//


import Foundation
import SwiftUI // Para @Published

class PokedexListViewModel: ObservableObject {
    private let pokemonManager = PokemonManager()
    
    @Published var pokemonList = [Pokemon]()
    @Published var searchText = ""

    // Propriedades para Paginação
    @Published var currentPage = 0 // Página atual
    private let itemsPerPage = 20 // Quantidade de itens por página
    @Published var isLoadingMorePokemon = false // Estado para controle de carregamento
    @Published var canLoadMorePokemon = true // Indica se há mais Pokémon para carregar
    
    // Usado com searchText para filtrar resultados de Pokémon
    var filteredPokemon: [Pokemon] {
        return searchText == "" ? pokemonList : pokemonList.filter { $0.name.contains(searchText.lowercased()) }
    }
    
    init() {
        loadMorePokemon() // Carrega a primeira página ao inicializar
    }
    

    
    // Função para carregar mais Pokémon (Paginação)
    func loadMorePokemon() {
        guard !isLoadingMorePokemon && canLoadMorePokemon else { return }
        
        isLoadingMorePokemon = true
        let offset = currentPage * itemsPerPage
        
        pokemonManager.getPokemon(limit: itemsPerPage, offset: offset) { [weak self] newPokemons in
            DispatchQueue.main.async {
                self?.pokemonList.append(contentsOf: newPokemons)
                self?.isLoadingMorePokemon = false
                
                if newPokemons.count < self?.itemsPerPage ?? 0 {
                    self?.canLoadMorePokemon = false
                } else {
                    self?.currentPage += 1
                }
            }
        } failure: { [weak self] error in
            DispatchQueue.main.async {
                print("Erro ao carregar mais Pokémon: \(error.localizedDescription)")
                self?.isLoadingMorePokemon = false
            }
        }
    }
    
    // Get the index of a pokemon ( index + 1 = pokemon id) - Movido para cá
    func getPokemonIndex(pokemon: Pokemon) -> Int {
        if let url = URL(string: pokemon.url),
           let lastPathComponent = url.lastPathComponent,
           let id = Int(lastPathComponent) {
            return id
        }
        // Fallback robusto para quando a URL não der certo
        // Seria melhor ter o ID diretamente no modelo Pokemon se possível pela API,
        // mas extrair da URL é a próxima melhor opção.
        return 0 // Retorna 0 ou lança erro/nil se o ID for crítico
    }
}

// Extensão para extrair o último componente do path da URL (o ID do Pokémon) - Mantida aqui
extension URL {
    var lastPathComponent: String? {
        // Ex: "https://pokeapi.co/api/v2/pokemon/1/" -> "1"
        // Remove a barra final, se houver, e pega o último componente
        let pathComponents = self.pathComponents
        if pathComponents.last == "/" && pathComponents.count > 1 {
            return pathComponents[pathComponents.count - 2]
        }
        return pathComponents.last
    }
}
