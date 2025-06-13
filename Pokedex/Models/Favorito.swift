import Foundation
import SwiftData

@Model
class Favorito {
    var id: UUID
    var pokemonId: Int
    var pokemonName: String
    var pokemonImageUrl: String?

 
    var usuario: Usuario?

    init(id: UUID = UUID(), pokemonId: Int, pokemonName: String, pokemonImageUrl: String? = nil, usuario: Usuario? = nil) {
        self.id = id
        self.pokemonId = pokemonId
        self.pokemonName = pokemonName
        self.pokemonImageUrl = pokemonImageUrl
        self.usuario = usuario
    }
}
