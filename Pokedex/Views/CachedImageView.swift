//
//  CachedImageView.swift
//  Pokedex
//
//  Created by user277066 on 6/13/25.
//


import SwiftUI

struct CachedImageView: View {
    let urlString: String
    let dimensions: Double
    let circleBackground: Bool

    @State private var image: UIImage? = nil
    @State private var isLoading = true
    @State private var hasError = false

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
                    .frame(width: dimensions, height: dimensions)
                    .background(circleBackground ? AppColors.detailBackground : AppColors.cardBackground)
                    .clipShape(circleBackground ? AnyShape(Circle()) : AnyShape(Rectangle()))
                    .scaleEffect(circleBackground ? 0.8 : 1.0)
                    .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: isLoading)

            } else if hasError {
                Image(systemName: "xmark.octagon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: dimensions, height: dimensions)
                    .foregroundColor(AppColors.errorText)
                    .background(circleBackground ? AppColors.detailBackground : AppColors.cardBackground)
                    .clipShape(circleBackground ? AnyShape(Circle()) : AnyShape(Rectangle()))

            } else if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: dimensions, height: dimensions)
                    .background(circleBackground ? AppColors.detailBackground : AppColors.cardBackground)
                    .clipShape(circleBackground ? AnyShape(Circle()) : AnyShape(Rectangle()))
                    .shadow(color: .black.opacity(circleBackground ? 0.3 : 0.2), radius: AppShadow.defaultShadow.radius * (circleBackground ? 2 : 1))
                    .transition(.opacity) // Suave transição ao aparecer
                    .animation(.easeIn(duration: 0.3), value: image)

            } else {
                // Fallback para caso não haja imagem e nem erro (estado inicial ou inesperado)
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: dimensions, height: dimensions)
                    .foregroundColor(AppColors.textSecondary)
                    .background(circleBackground ? AppColors.detailBackground : AppColors.cardBackground)
                    .clipShape(circleBackground ? AnyShape(Circle()) : AnyShape(Rectangle()))
            }
        }
        .onAppear(perform: loadImage)
        .onChange(of: urlString) { _,_ in loadImage() } // Recarrega se a URL mudar (ex: na paginação)
    }

    private func loadImage() {
        guard let url = URL(string: urlString) else {
            hasError = true
            isLoading = false
            return
        }

        isLoading = true
        hasError = false

        ImageCacheManager.shared.getImage(url: url) { uiImage in
            DispatchQueue.main.async {
                self.image = uiImage
                self.isLoading = false
                self.hasError = (uiImage == nil)
            }
        }
    }
}

struct AnyShape: Shape {
    private let makePath: (CGRect) -> Path

    init<S: Shape>(_ shape: S) {
        makePath = { rect in
            shape.path(in: rect)
        }
    }

    func path(in rect: CGRect) -> Path {
        makePath(rect)
    }
}
