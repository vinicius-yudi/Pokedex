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
        VStack {
            
            // Exibir a imagem do DetailPokemon (sprite padrão)
            if let pokemonDetails = vm.pokemonDetails {
                AsyncImage(url: URL(string: pokemonDetails.sprites.frontDefault ?? "")) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 150, height: 150) // Ajuste as dimensões conforme necessário

                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150) // Ajuste as dimensões
                            .background(.thinMaterial)
                            .clipShape(Circle())

                    case .failure(_):
                        Image(systemName: "xmark.octagon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .foregroundColor(.red)

                    @unknown default:
                        EmptyView()
                    }
                }
                .padding(.bottom, 10)
            } else {
                ProgressView() // Indicador enquanto os detalhes carregam
            }
            
            Text("\(pokemon.name.capitalized)")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 5)

            VStack(spacing: 10) {
                // Informações básicas já existentes
                Text("**ID**: \(vm.pokemonDetails?.id ?? 0)")
                Text("**Weight**: \(vm.formatHW(value: vm.pokemonDetails?.weight ?? 0)) KG")
                Text("**Height**: \(vm.formatHW(value: vm.pokemonDetails?.height ?? 0)) M")
                
                Divider() // Separador para organizar a visualização
                
                // Novas informações
                if let pokemonDetails = vm.pokemonDetails {
                    Text("**Types**: \(vm.getPokemonTypes(pokemon: pokemonDetails))")
                    
                    Text("**Abilities**: \(vm.getPokemonAbilities(pokemon: pokemonDetails))")
                    
                    VStack(alignment: .leading) {
                        Text("**Base Stats:**")
                        Text(vm.getPokemonStats(pokemon: pokemonDetails))
                            .font(.system(.body, design: .monospaced)) // Fonte monoespaçada para os stats
                    }
                } 
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(15)
            .shadow(radius: 5)
            
            Spacer()
        }
        .onAppear {
            vm.getDetails(pokemon: pokemon)
        }
        .navigationTitle(pokemon.name.capitalized)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PokemonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { // Adicione NavigationView para o preview funcionar corretamente
            PokemonDetailView(pokemon: Pokemon.samplePokemon)
                .environmentObject(ViewModel())
        }
    }
}
