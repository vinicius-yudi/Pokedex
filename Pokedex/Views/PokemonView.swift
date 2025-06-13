import SwiftUI

struct PokemonView: View {
    @EnvironmentObject var vm: ViewModel
    let pokemon: Pokemon
    let dimensions: Double = 140

    var body: some View {
        VStack {
            // Substituído AsyncImage por CachedImageView
            CachedImageView(urlString: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(vm.getPokemonIndex(pokemon: pokemon)).png",
                            dimensions: dimensions,
                            circleBackground: true) // É um círculo

            Text("\(pokemon.name.capitalized)")
                .font(AppFonts.capitalizedName())
                .foregroundColor(AppColors.textPrimary)
                .padding(.bottom, AppSpacing.medium)
        }
        .background(AppColors.cardBackground)
        .cornerRadius(AppCornerRadius.medium)
        .shadow(color: .black.opacity(0.2), radius: AppShadow.defaultShadow.radius, x: AppShadow.defaultShadow.x, y: AppShadow.defaultShadow.y)
        .padding(AppSpacing.xsmall)
    }
}
