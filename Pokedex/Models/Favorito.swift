import Foundation
import SwiftData

@Model
class Favorito {
    @Attribute(.unique) var id: UUID
    var pokemonId: Int
    var pokemonName: String
    var pokemonImageUrl: String?

    @Relationship var usuario: Usuario

    init(id: UUID = UUID(), pokemonId: Int, pokemonName: String, pokemonImageUrl: String? = nil, usuario: Usuario) {
        self.id = id
        self.pokemonId = pokemonId
        self.pokemonName = pokemonName
        self.pokemonImageUrl = pokemonImageUrl
        self.usuario = usuario
    }
}
