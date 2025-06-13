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

                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: dimensions, height: dimensions)

                case .failure(_):
                    Image(systemName: "xmark.octagon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: dimensions, height: dimensions)
                        .foregroundColor(.red)

                @unknown default:
                    EmptyView()
                }
            }
            .background(.thinMaterial)
            .clipShape(Circle())

            Text("\(pokemon.name.capitalized)")
                .font(.system(size: 16, weight: .regular, design: .monospaced))
                .padding(.bottom, 20)
        }
    }
}
