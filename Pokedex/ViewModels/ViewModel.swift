// Pokedex/ViewModels/ViewModel.swift

import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    private let pokemonManager = PokemonManager()
    
    @Published var pokemonList = [Pokemon]()
    @Published var pokemonDetails: DetailPokemon?
    @Published var searchText = ""

    // Propriedades para Paginação
    @Published var currentPage = 0 // Página atual
    private let itemsPerPage = 20 // Quantidade de itens por página
    @Published var isLoadingMorePokemon = false // Estado para controle de carregamento
    @Published var canLoadMorePokemon = true // Indica se há mais Pokémon para carregar
    
    // Used with searchText to filter pokemon results
    var filteredPokemon: [Pokemon] {
        return searchText == "" ? pokemonList : pokemonList.filter { $0.name.contains(searchText.lowercased()) }
    }
    
    init() {
        loadMorePokemon() // Carrega a primeira página ao inicializar
    }
    
    // Função para carregar mais Pokémon (Paginação)
    func loadMorePokemon() {
        guard !isLoadingMorePokemon && canLoadMorePokemon else { return } // Evita carregamentos múltiplos
        
        isLoadingMorePokemon = true
        let offset = currentPage * itemsPerPage
        
        pokemonManager.getPokemon(limit: itemsPerPage, offset: offset) { [weak self] newPokemons in
            DispatchQueue.main.async {
                self?.pokemonList.append(contentsOf: newPokemons)
                self?.isLoadingMorePokemon = false
                
                // Se a quantidade de Pokémon retornada for menor que o limite, não há mais para carregar
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
                // Você pode adicionar um alerta ou mensagem de erro na UI aqui
            }
        }
    }
    
    // Get the index of a pokemon ( index + 1 = pokemon id)
    func getPokemonIndex(pokemon: Pokemon) -> Int {
        if let index = self.pokemonList.firstIndex(of: pokemon) {
            // Este index é relativo à lista atual, não ao ID real da API
            // Para o ID real da API, você precisaria de um mapa ou calcular com base no offset
            // Por enquanto, se a URL for "https://pokeapi.co/api/v2/pokemon/X/", podemos extrair X.
            if let url = URL(string: pokemon.url),
               let lastPathComponent = url.lastPathComponent,
               let id = Int(lastPathComponent) {
                return id
            }
            return index + 1 // Fallback, mas pode não ser o ID correto para a API
        }
        return 0
    }
    
    // Get specific details for a pokemon
    func getDetails(pokemon: Pokemon) {
        let id = getPokemonIndex(pokemon: pokemon) // Usar o ID da API
        
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

// Extensão para extrair o último componente do path da URL (o ID do Pokémon)
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
