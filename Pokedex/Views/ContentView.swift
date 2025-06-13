// Pokedex/Views/ContentView.swift

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject var vm = PokedexListViewModel() // MODIFICADO: Usando PokedexListViewModel
    @State private var showAuthenticationView = true
    @State private var usuarioLogado: Usuario? = nil
    @State private var isSearching = false // Novo estado para controlar a visibilidade da barra de pesquisa

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
                VStack {
                    if isSearching {
                        SearchBarView(searchText: $vm.searchText, isSearching: $isSearching) // Subview para a barra de pesquisa
                            .transition(.move(edge: .top))
                    }

                    ScrollView {
                        LazyVGrid(columns: adaptiveColumns, spacing: AppSpacing.small) {
                            ForEach(vm.filteredPokemon) { pokemon in
                                NavigationLink(destination: PokemonDetailView(pokemon: pokemon)
                                    .toolbar(.hidden, for: .tabBar)
                                ) {
                                    PokemonView(pokemon: pokemon)
                                        .transition(.opacity) // Fade-in dos resultados
                                }
                            }

                          

                            // Trigger para carregar mais Pokémon quando o usuário chega ao fim da lista
                            if vm.canLoadMorePokemon && !vm.isLoadingMorePokemon && vm.searchText.isEmpty {
                                Color.clear
                                    .frame(height: 1)
                                    .onAppear {
                                        vm.loadMorePokemon()
                                    }
                            }
                        }
                        .animation(.default, value: vm.filteredPokemon.count) // Animação na mudança dos resultados
                    }
                }
                .background(AnimatedGradientBackground().ignoresSafeArea()) // Background animado
                .searchable(text: $vm.searchText)
                .navigationTitle("Pokedex")
                .font(AppFonts.pokedexTitle())
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            withAnimation {
                                isSearching.toggle()
                            }
                        }) {
                            Image(systemName: isSearching ? "xmark.circle.fill" : "magnifyingglass")
                                .foregroundColor(AppColors.accentColor)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Logout") {
                            usuarioLogado = nil
                            showAuthenticationView = true
                        }
                        .foregroundColor(AppColors.buttonPrimary)
                    }
                }
            }
            .environmentObject(vm)
            .tint(AppColors.accentColor)
        }
    }
}

struct SearchBarView: View {
    @Binding var searchText: String
    @Binding var isSearching: Bool

    var body: some View {
        TextField("Pesquisar Pokémon", text: $searchText)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
    }
}

struct AnimatedGradientBackground: View {
    @State private var gradientStart = UnitPoint.topLeading
    @State private var gradientEnd = UnitPoint.bottomTrailing

    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()

    var body: some View {
        LinearGradient(gradient: Gradient(colors: [AppColors.accentColor.opacity(0.3), AppColors.primaryBackground]), startPoint: gradientStart, endPoint: gradientEnd)
            .animation(.linear(duration: 2), value: gradientStart)
            .animation(.linear(duration: 2), value: gradientEnd)
            .onReceive(timer) { _ in
                withAnimation {
                    gradientStart = UnitPoint(x: Double.random(in: 0...1), y: Double.random(in: 0...1))
                    gradientEnd = UnitPoint(x: Double.random(in: 0...1), y: Double.random(in: 0...1))
                }
            }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .modelContainer(for: [Usuario.self, Favorito.self], inMemory: true)
    }
}
