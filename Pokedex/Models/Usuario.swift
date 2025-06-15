import Foundation
import SwiftData

@Model
class Usuario {
    var id: UUID
    var nomeDeUsuario: String
    var email: String
    var passwordHash: String

    @Relationship(deleteRule: .cascade) var favoritos: [Favorito]? // Relacionamento com Favorito

    init(id: UUID = UUID(), nomeDeUsuario: String, email: String, passwordHash: String) {
        self.id = id
        self.nomeDeUsuario = nomeDeUsuario
        self.email = email
        self.passwordHash = passwordHash
    }
}
