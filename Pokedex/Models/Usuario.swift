
import Foundation
import SwiftData

@Model
class Usuario {
    @Attribute(.unique) var id: UUID
    var nomeDeUsuario: String
    var email: String
    var passwordHash: String // Alterado de 'senha' para 'passwordHash'

    @Relationship(inverse: \Favorito.usuario) var favoritos: [Favorito] = []

    init(id: UUID = UUID(), nomeDeUsuario: String, email: String, passwordHash: String) {
        self.id = id
        self.nomeDeUsuario = nomeDeUsuario
        self.email = email
        self.passwordHash = passwordHash
    }
}
