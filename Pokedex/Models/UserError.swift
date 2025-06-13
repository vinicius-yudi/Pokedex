// Pokedex/Models/UserError.swift

import Foundation // Necessário para Error e LocalizedError

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
