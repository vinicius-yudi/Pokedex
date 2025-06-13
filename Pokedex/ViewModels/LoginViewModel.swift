//
//  LoginViewModel.swift
//  Pokedex
//
//  Created by user277066 on 6/12/25.
//


import Foundation
import SwiftUI
import SwiftData

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var senha = ""
    @Published var mensagemErro: String? = nil
    @Published var usuarioLogado: Usuario? = nil // Publica o usuário autenticado

    private var dataManager: DataManager!

    // Função para configurar o DataManager após a injeção do ModelContext
    func setupDataManager(modelContext: ModelContext) {
        self.dataManager = DataManager(modelContext: modelContext)
    }

    func fazerLogin() {
        mensagemErro = nil // Limpa mensagens de erro anteriores
        usuarioLogado = nil // Reseta o estado de usuário logado

        // Validações básicas
        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
           senha.isEmpty {
            mensagemErro = "E-mail e senha devem ser preenchidos."
            return
        }

        do {
            // Tenta autenticar o usuário usando o DataManager
            if let usuario = try dataManager.autenticarUsuario(email: email, password: senha) {
                self.usuarioLogado = usuario
                print("Login bem-sucedido para \(usuario.nomeDeUsuario)!")
            } else {
                mensagemErro = "E-mail ou senha inválidos." // Ou erro mais específico do DataManager
            }
        } catch let error as UserError {
            mensagemErro = error.localizedDescription
            print("Erro no login (UserError): \(error.localizedDescription)")
        } catch {
            mensagemErro = "Ocorreu um erro desconhecido no login."
            print("Erro desconhecido no login: \(error.localizedDescription)")
        }
    }
}
