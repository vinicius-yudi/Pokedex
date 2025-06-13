// Pokedex/Views/PokemonView.swift

import SwiftUI

struct PokemonView: View {
    @EnvironmentObject var vm: ViewModel
    let pokemon: Pokemon
    let dimensions: Double = 140

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(vm.getPokemonIndex(pokemon: pokemon)).png")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: dimensions, height: dimensions)
                        .background(AppColors.cardBackground)
                        .clipShape(Circle())
                        .opacity(0.8)

                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: dimensions, height: dimensions)
                        .background(AppColors.cardBackground)
                        .clipShape(Circle())
                        .transition(.opacity)

                case .failure(_):
                    Image(systemName: "xmark.octagon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: dimensions, height: dimensions)
                        .foregroundColor(AppColors.errorText)
                        .background(AppColors.cardBackground)
                        .clipShape(Circle())

                @unknown default:
                    EmptyView()
                }
            }
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
