//
//  DesignTokens.swift
//  Pokedex
//
//  Created by user277066 on 6/13/25.
//



import SwiftUI

// MARK: - Cores
enum AppColors {
    static let primaryBackground = Color(red: 0.95, green: 0.95, blue: 0.97) // Um cinza claro suave
    static let secondaryBackground = Color.white
    static let accentColor = Color.red // Cor principal da Pokedex, pode ser ajustado
    static let detailBackground = Color.white.opacity(0.8) // Fundo semitransparente para detalhes
    static let textPrimary = Color.black
    static let textSecondary = Color.gray
    static let buttonPrimary = Color.red
    static let buttonSecondary = Color.blue
    static let errorText = Color.red
    static let cardBackground = Color.white // Fundo dos cards de Pokémon
    static let typeNormal = Color(red: 0.65, green: 0.65, blue: 0.45)
    static let typeFire = Color(red: 0.95, green: 0.5, blue: 0.2)
    static let typeWater = Color(red: 0.25, green: 0.55, blue: 0.95)
    static let typeGrass = Color(red: 0.45, green: 0.75, blue: 0.35)
    static let typeElectric = Color(red: 0.95, green: 0.85, blue: 0.05)
    static let typeIce = Color(red: 0.5, green: 0.85, blue: 0.85)
    static let typeFighting = Color(red: 0.75, green: 0.25, blue: 0.2)
    static let typePoison = Color(red: 0.65, green: 0.25, blue: 0.65)
    static let typeGround = Color(red: 0.85, green: 0.75, blue: 0.35)
    static let typeFlying = Color(red: 0.5, green: 0.65, blue: 0.95)
    static let typePsychic = Color(red: 0.95, green: 0.35, blue: 0.55)
    static let typeBug = Color(red: 0.65, green: 0.75, blue: 0.15)
    static let typeRock = Color(red: 0.75, green: 0.65, blue: 0.25)
    static let typeGhost = Color(red: 0.45, green: 0.35, blue: 0.65)
    static let typeDragon = Color(red: 0.45, green: 0.25, blue: 0.95)
    static let typeSteel = Color(red: 0.7, green: 0.7, blue: 0.8)
    static let typeFairy = Color(red: 0.95, green: 0.6, blue: 0.8)
    static let typeDark = Color(red: 0.45, green: 0.35, blue: 0.3)
    static let typeNormalDark = Color(red: 0.45, green: 0.45, blue: 0.25) // Para textos sobre o tipo
    static let typeNormalLight = Color(red: 0.85, green: 0.85, blue: 0.65) // Para textos sobre o tipo
}

// MARK: - Fontes
enum AppFonts {
    static func pokedexTitle() -> Font {
        .system(size: 34, weight: .bold, design: .rounded)
    }
    static func largeTitle() -> Font {
        .largeTitle.bold()
    }
    static func headline() -> Font {
        .headline
    }
    static func subheadline() -> Font {
        .subheadline
    }
    static func body() -> Font {
        .body
    }
    static func monospacedBody() -> Font {
        .system(.body, design: .monospaced)
    }
    static func capitalizedName() -> Font {
        .system(size: 16, weight: .regular, design: .monospaced)
    }
}

// MARK: - Espaçamentos
enum AppSpacing {
    static let xsmall: CGFloat = 4
    static let small: CGFloat = 8
    static let medium: CGFloat = 16
    static let large: CGFloat = 24
    static let xlarge: CGFloat = 32
}

// MARK: - Corner Radius
enum AppCornerRadius {
    static let small: CGFloat = 8
    static let medium: CGFloat = 15 // Usado para cards/elementos principais
    static let large: CGFloat = 20
}

// MARK: - Sombras
enum AppShadow {
    static let defaultShadow = RadiusShadow(radius: 5, x: 0, y: 2) // Estrutura para sombra padrão
    // Pode expandir para diferentes tipos de sombra
}

struct RadiusShadow {
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// Extensão para facilitar o uso de cores de tipo
extension Color {
    static func typeColor(for type: String) -> Color {
        switch type.lowercased() {
        case "normal": return AppColors.typeNormal
        case "fire": return AppColors.typeFire
        case "water": return AppColors.typeWater
        case "grass": return AppColors.typeGrass
        case "electric": return AppColors.typeElectric
        case "ice": return AppColors.typeIce
        case "fighting": return AppColors.typeFighting
        case "poison": return AppColors.typePoison
        case "ground": return AppColors.typeGround
        case "flying": return AppColors.typeFlying
        case "psychic": return AppColors.typePsychic
        case "bug": return AppColors.typeBug
        case "rock": return AppColors.typeRock
        case "ghost": return AppColors.typeGhost
        case "dragon": return AppColors.typeDragon
        case "steel": return AppColors.typeSteel
        case "fairy": return AppColors.typeFairy
        case "dark": return AppColors.typeDark
        default: return AppColors.textSecondary // Cor padrão para tipos desconhecidos
        }
    }
}
