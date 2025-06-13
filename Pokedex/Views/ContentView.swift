//
//  ContentView.swift
//  Pokedex
//
//  Created by user277066 on 6/12/25.
//

import SwiftUI
import SwiftData // Importe SwiftData para o Usuario

struct ContentView: View {
    @StateObject var vm = ViewModel()
    @State private var showAuthenticationView = true // Estado para controlar a exibição da tela de autenticação
    @State private var usuarioLogado: Usuario? = nil // Armazena o usuário autenticado

    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        // Se o usuário não está logado, mostra a tela de autenticação
        // Caso contrário, mostra o conteúdo principal do Pokedex
        if showAuthenticationView || usuarioLogado == nil {
            AuthenticationView(usuarioAtual: $usuarioLogado)
                .onChange(of: usuarioLogado) { oldUser, newUser in
                    if newUser != nil {
                        // Se um usuário foi logado, ocultar a tela de autenticação
                        showAuthenticationView = false
                    }
                }
        } else {
            // Conteúdo principal do Pokedex (lista de Pokémon)
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: adaptiveColumns, spacing: 10) {
                        ForEach(vm.filteredPokemon) { pokemon in
                            NavigationLink(destination: PokemonDetailView(pokemon: pokemon)
                            ) {
                                PokemonView(pokemon: pokemon)
                            }
                        }
                    }
                    .animation(.easeInOut(duration: 0.3), value: vm.filteredPokemon.count)
                    .navigationTitle("Pokedex")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Logout") {
                                // Implementar a lógica de logout (limpar usuarioLogado)
                                usuarioLogado = nil
                                showAuthenticationView = true
                            }
                        }
                    }
                }
                .searchable(text: $vm.searchText)
            }
            .environmentObject(vm)
            // Aqui você também pode injetar o usuarioLogado no ambiente se as sub-views precisarem
            // .environment(\.usuarioLogado, usuarioLogado) - se criar um EnvironmentKey para isso
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .modelContainer(for: [Usuario.self, Favorito.self], inMemory: true) // Para o preview
    }
}
