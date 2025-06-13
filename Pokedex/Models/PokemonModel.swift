import Foundation


struct PokemonPage: Codable {
    let count: Int
    let next: String? // next pode ser nulo se não houver mais páginas
    let previous: String? // previous pode ser nulo
    let results: [Pokemon]
}

struct Pokemon: Codable, Identifiable, Equatable {
    let id = UUID()
    let name: String
    let url: String

    static var samplePokemon = Pokemon(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/")
}

struct DetailPokemon: Codable {
    let id: Int
    let height: Int
    let weight: Int
    let sprites: Sprites // Adicionar sprites
    let types: [PokemonType] // Adicionar tipos
    let abilities: [PokemonAbility] // Adicionar habilidades
    let stats: [PokemonStat] // Adicionar stats
    // Você pode adicionar moves aqui também se precisar
}

// Novas structs para objetos JSON aninhados
struct Sprites: Codable {
    let frontDefault: String? // URL para o sprite padrão da frente
    // Adicione outros sprites conforme necessário, ex: backDefault, frontShiny, etc.
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct PokemonType: Codable {
    let slot: Int
    let type: TypeInfo
}

struct TypeInfo: Codable {
    let name: String
    let url: String
}

struct PokemonAbility: Codable {
    let ability: AbilityInfo
    let isHidden: Bool
    let slot: Int

    enum CodingKeys: String, CodingKey {
        case ability
        case isHidden = "is_hidden"
        case slot
    }
}

struct AbilityInfo: Codable {
    let name: String
    let url: String
}

struct PokemonStat: Codable {
    let baseStat: Int
    let effort: Int
    let stat: StatInfo

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort
        case stat
    }
}

struct StatInfo: Codable {
    let name: String
    let url: String
}
