// Pokedex/Views/PokemonDetailView.swift
//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by user277066 on 6/12/25.
//

import SwiftUI

struct PokemonDetailView: View {
    // Não precisa mais de @EnvironmentObject var vm: ViewModel
    // Agora tem seu próprio ViewModel
    @StateObject var vm: PokemonDetailViewModel // MODIFICADO: Usando PokemonDetailViewModel
    
    // O initializer agora recebe um Pokemon e cria a ViewModel
    init(pokemon: Pokemon) {
        // Inicializa a StateObject com a ViewModel específica para este Pokémon
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
                    // Imagem do Pokémon - PokemonImageView agora usa a nova PokemonDetailViewModel
                    PokemonImageView(vm: vm) // Passa a ViewModel diretamente para a subview
                        .padding(.top, AppSpacing.large)
                        .padding(.bottom, AppSpacing.medium)

                    // Nome do Pokémon
                    Text("\(vm.pokemon.name.capitalized)") // Acessando o nome do pokemon da ViewModel
                        .font(AppFonts.largeTitle())
                        .foregroundColor(AppColors.textPrimary)
                        .padding(.bottom, AppSpacing.small)

                    // Informações Detalhadas (Fundo do Card)
                    VStack(spacing: AppSpacing.medium) {
                        // ID, Peso, Altura - PokemonBasicInfoView agora usa a nova PokemonDetailViewModel
                        PokemonBasicInfoView(pokemonDetails: vm.pokemonDetails, vm: vm)
                            .font(AppFonts.body())
                            .foregroundColor(AppColors.textPrimary)
                        
                        Divider() // Separador

                        // Tipos - PokemonTypesSection
                        if let pokemonDetails = vm.pokemonDetails {
                            PokemonTypesSection(pokemonDetails: pokemonDetails)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, AppSpacing.xsmall)

                            // Habilidades - PokemonAbilitiesSection agora usa a nova PokemonDetailViewModel
                            PokemonAbilitiesSection(pokemonDetails: pokemonDetails, vm: vm)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Divider() // Separador

                            // Stats Base - PokemonStatsSection
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
        // Removido .onAppear { vm.getDetails(pokemon: pokemon) } pois o init da ViewModel já faz isso
        .navigationTitle(vm.pokemon.name.capitalized) // Acessando o nome do pokemon da ViewModel
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Subviews para PokemonDetailView

// Esta struct PokemonImageView agora usa a PokemonDetailViewModel
struct PokemonImageView: View {
    @ObservedObject var vm: PokemonDetailViewModel

    var body: some View {
        Group {
            // Acesso aos detalhes através da ViewModel
            if let pokemonDetails = vm.pokemonDetails {
                CachedImageView(urlString: pokemonDetails.sprites.frontDefault ?? "",
                                dimensions: 200,
                                circleBackground: true)
                    .shadow(color: .black.opacity(0.3), radius: AppShadow.defaultShadow.radius * 2)
                    .animation(.easeOut(duration: 0.4), value: vm.pokemonDetails == nil)
            } else {
                // Indicador de carregamento enquanto os detalhes são buscados ou há erro
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

// Esta struct é para as informações básicas (ID, Peso, Altura)
struct PokemonBasicInfoView: View {
    let pokemonDetails: DetailPokemon?
    @ObservedObject var vm: PokemonDetailViewModel // MODIFICADO

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
                Text("\(vm.formatHW(value: pokemonDetails?.weight ?? 0)) KG") // Chamada de método da nova ViewModel
            }
            HStack {
                Text("**Altura:**")
                Spacer()
                Text("\(vm.formatHW(value: pokemonDetails?.height ?? 0)) M") // Chamada de método da nova ViewModel
            }
        }
    }
}

// Esta struct é para a seção de Tipos
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

// Esta struct é para a seção de Habilidades
struct PokemonAbilitiesSection: View {
    let pokemonDetails: DetailPokemon
    @ObservedObject var vm: PokemonDetailViewModel // MODIFICADO

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xsmall) {
            Text("**Habilidades:**")
                .font(AppFonts.headline())
            Text(vm.getPokemonAbilities(pokemon: pokemonDetails)) // Chamada de método da nova ViewModel
                .font(AppFonts.body())
                .foregroundColor(AppColors.textPrimary)
        }
    }
}

// Esta struct é para a seção de Stats Base
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
            // No Preview, crie uma instância de PokemonDetailView com um Pokémon de exemplo
            // A ViewModel será criada automaticamente no init da view
            PokemonDetailView(pokemon: Pokemon.samplePokemon)
        }
        // Para que o Preview funcione corretamente com SwiftData, você precisa fornecer um ModelContainer
        .modelContainer(for: [Usuario.self, Favorito.self], inMemory: true)
    }
}
