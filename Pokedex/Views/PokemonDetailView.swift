// Pokedex/Views/PokemonDetailView.swift
// (Conteúdo COMPLETO do arquivo)

import SwiftUI


struct PokemonDetailView: View {
    @StateObject var vm: PokemonDetailViewModel
    @EnvironmentObject var mainVM: FavoritosViewModel
    
    

    // O initializer agora recebe apenas o Pokemon
    init(pokemon: Pokemon) { 
        _vm = StateObject(wrappedValue: PokemonDetailViewModel(pokemon: pokemon))
    }
    
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
                    PokemonImageView(vm: vm)
                        .padding(.top, AppSpacing.large)
                        .padding(.bottom, AppSpacing.medium)

                    // Nome do Pokémon
                    Text("\(vm.pokemon.name.capitalized)")
                        .font(AppFonts.largeTitle())
                        .foregroundColor(AppColors.textPrimary)
                        .padding(.bottom, AppSpacing.small)

                    // Informações Detalhadas (Fundo do Card)
                    VStack(spacing: AppSpacing.medium) {
                        PokemonBasicInfoView(pokemonDetails: vm.pokemonDetails, vm: vm)
                            .font(AppFonts.body())
                            .foregroundColor(AppColors.textPrimary)
                        
                        Divider() // Separador

                        if let pokemonDetails = vm.pokemonDetails {
                            PokemonTypesSection(pokemonDetails: pokemonDetails)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, AppSpacing.xsmall)

                            PokemonAbilitiesSection(pokemonDetails: pokemonDetails, vm: vm)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Divider() // Separador

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

                    // BOTÃO PARA NAVEGAR PARA FAVORITOS
                    NavigationLink(destination: FavoritosView()) { // NAVEGA PARA FavoritosView
                        Label("Favoritar Pokemon", systemImage: "heart.fill")
                            .font(AppFonts.headline())
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(AppColors.buttonSecondary) // Usando uma cor de botão secundária
                            .cornerRadius(AppCornerRadius.medium)
                            .shadow(color: .black.opacity(0.1), radius: AppShadow.defaultShadow.radius)
                    }
                    .padding(.horizontal, AppSpacing.medium)
                    .padding(.bottom, AppSpacing.medium)
                }
                
            }
        }
        .onAppear {
            vm.getDetails() // Apenas carrega detalhes, sem lógica de favoritos
        }
        // Removido: .onChange(of: usuarioAtual)
        .navigationTitle(vm.pokemon.name.capitalized)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Subviews para PokemonDetailView (mantidas as mesmas, sem modificações de favoritos)

struct PokemonImageView: View {
    @ObservedObject var vm: PokemonDetailViewModel

    var body: some View {
        Group {
            if let pokemonDetails = vm.pokemonDetails {
                CachedImageView(urlString: pokemonDetails.sprites.frontDefault ?? "",
                                dimensions: 200,
                                circleBackground: true)
                    .shadow(color: .black.opacity(0.3), radius: AppShadow.defaultShadow.radius * 2)
                    .animation(.easeOut(duration: 0.4), value: vm.pokemonDetails == nil)
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
    @ObservedObject var vm: PokemonDetailViewModel

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
    @ObservedObject var vm: PokemonDetailViewModel

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
    // Removido: @State static var previewUsuario
    static var previews: some View {
        NavigationView {
            PokemonDetailView(pokemon: Pokemon.samplePokemon) // Removido usuarioAtual
        }
        // Não precisa de .modelContainer aqui se não estamos usando SwiftData na preview
    }
}
