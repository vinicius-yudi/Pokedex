//
//  ImageCacheManager.swift
//  Pokedex
//
//  Created by user277066 on 6/13/25.
//


import SwiftUI 
import Foundation

class ImageCacheManager {
    static let shared = ImageCacheManager() // Singleton

    private let cache = NSCache<NSString, UIImage>() // Cache em memória

    private init() {} // Garante que apenas uma instância seja criada

    func getImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        // 1. Tenta obter a imagem do cache em memória
        if let cachedImage = cache.object(forKey: url.absoluteString as NSString) {
            print("Imagem carregada do cache: \(url.lastPathComponent)")
            completion(cachedImage)
            return
        }

        // 2. Se não estiver no cache, baixa a imagem da rede
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else {
                print("Erro ao baixar imagem: \(error?.localizedDescription ?? "Erro desconhecido")")
                completion(nil)
                return
            }

            if let image = UIImage(data: data) {
                // 3. Salva a imagem no cache
                self.cache.setObject(image, forKey: url.absoluteString as NSString)
                print("Imagem baixada e adicionada ao cache: \(url.lastPathComponent)")
                completion(image)
            } else {
                print("Não foi possível criar UIImage a partir dos dados.")
                completion(nil)
            }
        }.resume()
    }

    // Método opcional para limpar o cache (útil para testes ou logout)
    func clearCache() {
        cache.removeAllObjects()
        print("Cache de imagens limpo.")
    }
}
