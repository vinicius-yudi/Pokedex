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
}
