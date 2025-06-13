// Pokedex/Views/PokemonDetailView.swift
//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by user277066 on 6/12/25.
//

import SwiftUI

struct PokemonDetailView: View {
    @EnvironmentObject var vm: ViewModel
    let pokemon: Pokemon
    
    var body: some View {
        ZStack {
            // Fundo gradiente ou uma cor baseada no tipo principal do Pokémon
            if let pokemonDetails = vm.pokemonDetails,
               let firstType = pokemonDetails.types.first?.type.name {
                LinearGradient(gradient: Gradient(colors: [Color.typeColor(for: firstType).opacity(0.7), AppColors.primaryBackground]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            } else {
                AppColors.primaryBackground.ignoresSafeArea()
            }

            ScrollView {
                VStack(spacing: AppSpacing.large) {
                    // Imagem do Pokémon
                    PokemonImageView(vm: vm, pokemon: pokemon)
                        .padding(.top, AppSpacing.large)
                        .padding(.bottom, AppSpacing.medium)

                    // Nome do Pokémon
                    Text("\(pokemon.name.capitalized)")
                        .font(AppFonts.largeTitle())
                        .foregroundColor(AppColors.textPrimary)
                        .padding(.bottom, AppSpacing.small)

                    // Informações Detalhadas (Fundo do Card)
                    VStack(spacing: AppSpacing.medium) {
                        // ID, Peso, Altura
                        PokemonBasicInfoView(pokemonDetails: vm.pokemonDetails, vm: vm)
                            .font(AppFonts.body())
                            .foregroundColor(AppColors.textPrimary)
                        
                        Divider() // Separador

                        // Tipos
                        if let pokemonDetails = vm.pokemonDetails {
                            PokemonTypesSection(pokemonDetails: pokemonDetails)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, AppSpacing.xsmall)

                            // Habilidades
                            PokemonAbilitiesSection(pokemonDetails: pokemonDetails, vm: vm)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Divider() // Separador

                            // Stats Base
                            PokemonStatsSection(pokemonDetails: pokemonDetails)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(AppSpacing.large)
                    .background(AppColors.secondaryBackground)
                    .cornerRadius(AppCornerRadius.large)
                    .shadow(color: .black.opacity(0.2), radius: AppShadow.defaultShadow.radius, x: AppShadow.defaultShadow.x, y: AppShadow.defaultShadow.y)
                    .padding(.horizontal, AppSpacing.medium)
                    .padding(.bottom, AppSpacing.xlarge)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    
                }
            }
        }
        .onAppear {
            vm.getDetails(pokemon: pokemon)
        }
        .navigationTitle(pokemon.name.capitalized)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Subviews para PokemonDetailView

struct PokemonImageView: View {
    @ObservedObject var vm: ViewModel // Usar ObservedObject para VM
    let pokemon: Pokemon

    var body: some View {
        Group { // Usar Group para o indicador de carregamento
            if let pokemonDetails = vm.pokemonDetails {
                AsyncImage(url: URL(string: pokemonDetails.sprites.frontDefault ?? "")) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 200, height: 200)
                            .background(AppColors.detailBackground)
                            .clipShape(Circle())
                            .scaleEffect(0.8)
                            .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true))

                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .background(AppColors.detailBackground)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.3), radius: AppShadow.defaultShadow.radius * 2)
                            .transition(.scale)
                            .animation(.easeInOut(duration: 0.7))

                    case .failure(_):
                        Image(systemName: "xmark.octagon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .foregroundColor(AppColors.errorText)
                            .background(AppColors.detailBackground)
                            .clipShape(Circle())
                            .animation(.easeInOut(duration: 0.7))

                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                ProgressView("Carregando imagem...")
                    .font(AppFonts.headline())
                    .foregroundColor(AppColors.textPrimary)
                    .padding()
                    .frame(width: 200, height: 200)
                    .background(AppColors.detailBackground)
                    .cornerRadius(AppCornerRadius.medium)
                    .shadow(color: .black.opacity(0.1), radius: AppShadow.defaultShadow.radius)
                    .animation(.easeOut(duration: 0.4), value: vm.pokemonDetails == nil)
            }
        }
    }
}

struct PokemonBasicInfoView: View {
    let pokemonDetails: DetailPokemon?
    @ObservedObject var vm: ViewModel // Usar ObservedObject para VM

    var body: some View {
        Group {
            HStack {
                Text("**ID:**")
                Spacer()
                Text("\(pokemonDetails?.id ?? 0)")
            }
            HStack {
                Text("**Peso:**")
                Spacer()
                Text("\(vm.formatHW(value: pokemonDetails?.weight ?? 0)) KG")
            }
            HStack {
                Text("**Altura:**")
                Spacer()
                Text("\(vm.formatHW(value: pokemonDetails?.height ?? 0)) M")
            }
        }
    }
}

struct PokemonTypesSection: View {
    let pokemonDetails: DetailPokemon

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xsmall) {
            Text("**Tipos:**")
                .font(AppFonts.headline())
            HStack {
                ForEach(pokemonDetails.types, id: \.slot) { typeInfo in
                    Text(typeInfo.type.name.capitalized)
                        .font(AppFonts.subheadline())
                        .padding(.horizontal, AppSpacing.small)
                        .padding(.vertical, AppSpacing.xsmall)
                        .background(Color.typeColor(for: typeInfo.type.name))
                        .cornerRadius(AppCornerRadius.small)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.1), radius: AppShadow.defaultShadow.radius)
                }
            }
        }
    }
}

struct PokemonAbilitiesSection: View {
    let pokemonDetails: DetailPokemon
    @ObservedObject var vm: ViewModel // Usar ObservedObject para VM

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xsmall) {
            Text("**Habilidades:**")
                .font(AppFonts.headline())
            Text(vm.getPokemonAbilities(pokemon: pokemonDetails))
                .font(AppFonts.body())
                .foregroundColor(AppColors.textPrimary)
        }
    }
}

struct PokemonStatsSection: View {
    let pokemonDetails: DetailPokemon

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xsmall) {
            Text("**Stats Base:**")
                .font(AppFonts.headline())
            ForEach(pokemonDetails.stats, id: \.stat.name) { stat in
                HStack {
                    Text("\(stat.stat.name.capitalized):")
                        .font(AppFonts.body())
                        .foregroundColor(AppColors.textPrimary)
                    Spacer()
                    Text("\(stat.baseStat)")
                        .font(AppFonts.monospacedBody())
                        .foregroundColor(AppColors.textPrimary)
                    ProgressView(value: Double(stat.baseStat), total: 255)
                        .progressViewStyle(LinearProgressViewStyle(tint: stat.baseStat > 90 ? .green : (stat.baseStat > 60 ? .yellow : .red)))
                        .frame(width: 100)
                }
            }
        }
    }
}

// MARK: - Preview

struct PokemonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PokemonDetailView(pokemon: Pokemon.samplePokemon)
                .environmentObject(ViewModel())
        }
    }
}
