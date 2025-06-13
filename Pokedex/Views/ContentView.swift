// Pokedex/Views/ContentView.swift

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject var vm = ViewModel()
    @State private var showAuthenticationView = true
    @State private var usuarioLogado: Usuario? = nil

    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        if showAuthenticationView || usuarioLogado == nil {
            AuthenticationView(usuarioAtual: $usuarioLogado)
                .onChange(of: usuarioLogado) { oldUser, newUser in
                    if newUser != nil {
                        showAuthenticationView = false
                    }
                }
        } else {
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: adaptiveColumns, spacing: AppSpacing.small) {
                        ForEach(vm.filteredPokemon) { pokemon in
                            NavigationLink(destination: PokemonDetailView(pokemon: pokemon)
                                .toolbar(.hidden, for: .tabBar)
                            ) {
                                PokemonView(pokemon: pokemon)
                            }
                        }

                        // Indicador de Carregamento para Paginação
                        if vm.isLoadingMorePokemon {
                            ProgressView()
                                .padding()
                                .controlSize(.large)
                        }

                        // Trigger para carregar mais Pokémon quando o usuário chega ao fim da lista
                        if vm.canLoadMorePokemon && !vm.isLoadingMorePokemon && vm.searchText.isEmpty { // Só carrega mais se não estiver buscando
                            Color.clear
                                .frame(height: 1) // Um ponto invisível
                                .onAppear {
                                    vm.loadMorePokemon()
                                }
                        }
                    }
                    .animation(.easeInOut(duration: 0.3), value: vm.filteredPokemon.count)
                    .navigationTitle("Pokedex")
                    .font(AppFonts.pokedexTitle())
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Logout") {
                                usuarioLogado = nil
                                showAuthenticationView = true
                            }
                            .foregroundColor(AppColors.buttonPrimary)
                        }
                    }
                }
                .searchable(text: $vm.searchText)
                .background(AppColors.primaryBackground.ignoresSafeArea())
            }
            .environmentObject(vm)
            .tint(AppColors.accentColor)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .modelContainer(for: [Usuario.self, Favorito.self], inMemory: true)
    }
}
