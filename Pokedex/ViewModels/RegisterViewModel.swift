// Pokedex/ViewModels/CadastroViewModel.swift

import Foundation
import SwiftUI
import SwiftData // Necessário para @Environment(\.modelContext)

class CadastroViewModel: ObservableObject {
    @Published var nomeDeUsuario = ""
    @Published var email = ""
    @Published var senha = ""
    @Published var confirmarSenha = ""
    @Published var mensagemErro: String? = nil
    @Published var cadastroSucesso: Bool = false

    private var dataManager: DataManager!

    // Função para configurar o DataManager após a injeção do ModelContext
    func setupDataManager(modelContext: ModelContext) {
        self.dataManager = DataManager(modelContext: modelContext)
    }

    func registrarUsuario() {
        mensagemErro = nil // Limpa mensagens de erro anteriores
        cadastroSucesso = false // Reseta o estado de sucesso

        // Validações básicas
        if nomeDeUsuario.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
           email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
           senha.isEmpty ||
           confirmarSenha.isEmpty {
            mensagemErro = "Todos os campos devem ser preenchidos."
            return
        }

        if senha != confirmarSenha {
            mensagemErro = "As senhas não coincidem."
            return
        }

        // Validação de email (básica, pode ser mais robusta)
        if !isValidEmail(email) {
            mensagemErro = "Formato de e-mail inválido."
            return
        }

        // Você pode adicionar validação de força de senha aqui (ex: mínimo de caracteres, etc.)
        if senha.count < 6 {
            mensagemErro = "A senha deve ter no mínimo 6 caracteres."
            return
        }

        do {
            // Verificar se o usuário já existe antes de tentar criar
            if try dataManager.usuarioExiste(email: email) { // Agora usa 'try'
                mensagemErro = "Este e-mail já está cadastrado."
                return
            }
            
            // Tenta criar o usuário usando o DataManager
            _ = try dataManager.criarUsuario(nomeDeUsuario: nomeDeUsuario, email: email, password: senha) // Agora usa 'try'
            cadastroSucesso = true
            print("Cadastro realizado com sucesso para \(nomeDeUsuario)!")
        } catch let error as UserError { // Captura UserError específico
            mensagemErro = error.localizedDescription
            print("Erro no registro (UserError): \(error.localizedDescription)")
        } catch { // Captura outros erros
            mensagemErro = "Erro desconhecido ao registrar usuário: \(error.localizedDescription)"
            print("Erro no registro (desconhecido): \(error.localizedDescription)")
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
