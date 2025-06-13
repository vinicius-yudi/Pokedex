// Pokedex/Managers/DataManager.swift

import Foundation
import SwiftData
import CryptoKit

class DataManager {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - Autenticação de Usuário

    func criarUsuario(nomeDeUsuario: String, email: String, password plaintextPassword: String) throws -> Usuario {
        let predicate = #Predicate<Usuario> { $0.email == email }
        let descriptor = FetchDescriptor(predicate: predicate)
        if try modelContext.fetch(descriptor).first != nil {
            throw UserError.userAlreadyExists
        }

        let hashedPassword = hashPassword(plaintextPassword)
        let novoUsuario = Usuario(nomeDeUsuario: nomeDeUsuario, email: email, passwordHash: hashedPassword)
        modelContext.insert(novoUsuario)
        try modelContext.save()
        print("Usuário \(nomeDeUsuario) criado com sucesso!")
        return novoUsuario
    }

    func autenticarUsuario(email: String, password plaintextPassword: String) throws -> Usuario? {
        let predicate = #Predicate<Usuario> { $0.email == email }
        let descriptor = FetchDescriptor(predicate: predicate)

        guard let usuario = try modelContext.fetch(descriptor).first else {
            return nil
        }

        if verifyPassword(plaintextPassword, hashed: usuario.passwordHash) {
            print("Usuário \(usuario.nomeDeUsuario) autenticado com sucesso!")
            return usuario
        } else {
            return nil
        }
    }

    // MARK: - Funções de Hashing de Senha

    private func hashPassword(_ password: String) -> String {
        let data = Data(password.utf8)
        let digest = SHA256.hash(data: data)
        return digest.compactMap { String(format: "%02x", $0) }.joined()
    }

    private func verifyPassword(_ plaintext: String, hashed: String) -> Bool {
        return hashPassword(plaintext) == hashed
    }
    
    func usuarioExiste(email: String) throws -> Bool {
        let predicate = #Predicate<Usuario> { $0.email == email }
        let descriptor = FetchDescriptor(predicate: predicate)
        let count = try modelContext.fetchCount(descriptor)
        return count > 0
    }

    // MARK: - Operações de Pokémon Favorito

    func adicionarFavorito(pokemonId: Int, pokemonName: String, pokemonImageUrl: String?, para usuario: Usuario) throws {
        // PREDICADO CORRIGIDO: Usa if let para desempacotar o opcional
        let predicate = #Predicate<Favorito> { favorito in
            favorito.pokemonId == pokemonId && {
                if let favUsuario = favorito.usuario {
                    return favUsuario.id == usuario.id
                }
                return false
            }()
        }
        let descriptor = FetchDescriptor(predicate: predicate)

        if try modelContext.fetch(descriptor).first != nil {
            print("Pokémon já favoritado por este usuário.")
            return
        }

        let novoFavorito = Favorito(pokemonId: pokemonId, pokemonName: pokemonName, pokemonImageUrl: pokemonImageUrl, usuario: usuario)
        modelContext.insert(novoFavorito)
        try modelContext.save()
        print("Pokémon \(pokemonName) adicionado aos favoritos para \(usuario.nomeDeUsuario)!")
    }

    func removerFavorito(pokemonId: Int, para usuario: Usuario) throws {
        // PREDICADO CORRIGIDO: Usa if let para desempacotar o opcional
        let predicate = #Predicate<Favorito> { favorito in
            favorito.pokemonId == pokemonId && {
                if let favUsuario = favorito.usuario {
                    return favUsuario.id == usuario.id
                }
                return false
            }()
        }
        let descriptor = FetchDescriptor(predicate: predicate)

        if let favoritoParaRemover = try modelContext.fetch(descriptor).first {
            modelContext.delete(favoritoParaRemover)
            try modelContext.save()
            print("Pokémon (ID: \(pokemonId)) removido dos favoritos para \(usuario.nomeDeUsuario).")
        } else {
            print("Pokémon (ID: \(pokemonId)) não encontrado nos favoritos para \(usuario.nomeDeUsuario).")
        }
    }

    func isPokemonFavorito(pokemonId: Int, para usuario: Usuario) throws -> Bool {
        // PREDICADO CORRIGIDO: Usa if let para desempacotar o opcional
        let predicate = #Predicate<Favorito> { favorito in
            favorito.pokemonId == pokemonId && {
                if let favUsuario = favorito.usuario {
                    return favUsuario.id == usuario.id
                }
                return false
            }()
        }
        let descriptor = FetchDescriptor(predicate: predicate)
        return try modelContext.fetch(descriptor).first != nil
    }
    
    func buscarFavoritos(para usuario: Usuario) -> [Favorito] {
        // PREDICADO CORRIGIDO: Usa if let para desempacotar o opcional
        let predicate = #Predicate<Favorito> { favorito in
            if let favUsuario = favorito.usuario {
                return favUsuario.id == usuario.id
            }
            return false
        }
        do {
            let descriptor = FetchDescriptor(predicate: predicate, sortBy: [SortDescriptor(\.pokemonName)])
            return try modelContext.fetch(descriptor)
        } catch {
            print("Erro ao buscar favoritos: \(error.localizedDescription)")
            return []
        }
    }
}

enum UserError: Error, LocalizedError {
    case userAlreadyExists
    case authenticationFailed

    var errorDescription: String? {
        switch self {
        case .userAlreadyExists:
            return NSLocalizedString("Um usuário com este e-mail já existe.", comment: "User Exists Error")
        case .authenticationFailed:
            return NSLocalizedString("E-mail ou senha inválidos.", comment: "Authentication Failed Error")
        }
    }
}
