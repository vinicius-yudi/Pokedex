////
////  FavoritosDataManager.swift
////  Pokedex
////
////  Created by user277066 on 6/13/25.
////
//// Pokedex/Managers/FavoritosDataManager.swift
//
//import Foundation
//import SwiftData
//
//class FavoritosDataManager {
//    private let modelContext: ModelContext
//
//    init(modelContext: ModelContext) {
//        self.modelContext = modelContext
//    }
//
//    func adicionarFavorito(pokemonId: Int, pokemonName: String, pokemonImageUrl: String?, para usuario: Usuario) throws {
//        // Verifica se o favorito já existe para este usuário
//        let predicate = #Predicate<Favorito> {
//            $0.pokemonId == pokemonId && $0.usuario == usuario
//        }
//        let descriptor = FetchDescriptor(predicate: predicate)
//        let existingFavorites = try modelContext.fetch(descriptor)
//
//        guard existingFavorites.isEmpty else {
//            print("Pokémon \(pokemonName) já está nos favoritos do usuário \(usuario.nomeDeUsuario).")
//            return // Já é um favorito, não faz nada
//        }
//
//        let novoFavorito = Favorito(pokemonId: pokemonId, pokemonName: pokemonName, pokemonImageUrl: pokemonImageUrl, usuario: usuario)
//        modelContext.insert(novoFavorito)
//        try modelContext.save()
//        print("Pokémon \(pokemonName) adicionado aos favoritos de \(usuario.nomeDeUsuario).")
//    }
//
//    func removerFavorito(pokemonId: Int, de usuario: Usuario) throws {
//        let predicate = #Predicate<Favorito> { $0.pokemonId == pokemonId && $0.usuario == usuario
//        }
//        let descriptor = FetchDescriptor(predicate: predicate)
//        let favoritesToRemove = try modelContext.fetch(descriptor)
//
//        for favorito in favoritesToRemove {
//            modelContext.delete(favorito)
//        }
//        try modelContext.save()
//        print("Pokémon com ID \(pokemonId) removido dos favoritos de \(usuario.nomeDeUsuario).")
//    }
//
//    func isFavorito(pokemonId: Int, para usuario: Usuario) throws -> Bool {
//        let predicate = #Predicate<Favorito> {
//            $0.pokemonId == pokemonId && $0.usuario == usuario
//        }
//        let descriptor = FetchDescriptor(predicate: predicate)
//        let count = try modelContext.fetchCount(descriptor)
//        return count > 0
//    }
//
//    func buscarFavoritos(para usuario: Usuario) throws -> [Favorito] {
//        let predicate = #Predicate<Favorito> {
//            $0.usuario == usuario
//        }
//        // Ordena por nome para uma lista mais organizada
//        let descriptor = FetchDescriptor(predicate: predicate, sortBy: [SortDescriptor(\.pokemonName)])
//        return try modelContext.fetch(descriptor)
//    }
//}
