//
//  FavoritosView.swift
//  Pokedex
//
//  Created by user277066 on 6/13/25.
//


import SwiftUI

struct FavoritosView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "heart.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.red)
                    .padding()
                Text("Esta é a tela de Favoritos!")
                    .font(.title)
                    .padding()
                Text("")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .navigationTitle("Meus Favoritos")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct FavoritosView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritosView()
    }
}
