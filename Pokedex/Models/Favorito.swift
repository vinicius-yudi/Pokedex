import Foundation
import SwiftData

@Model
class Favorito {
    var id: UUID
    var pokemonId: Int // ID numérico do Pokémon da PokeAPI (ex: 1 para Bulbasaur)
    var pokemonName: String
    var pokemonImageUrl: String? // URL da imagem para exibição na lista de favoritos

    @Relationship var usuario: Usuario? // Relacionamento com o usuário que favoritou

    init(id: UUID = UUID(), pokemonId: Int, pokemonName: String, pokemonImageUrl: String? = nil, usuario: Usuario? = nil) {
        self.id = id
        self.pokemonId = pokemonId
        self.pokemonName = pokemonName
        self.pokemonImageUrl = pokemonImageUrl
        self.usuario = usuario
    }
}
