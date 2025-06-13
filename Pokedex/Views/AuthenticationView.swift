// Pokedex/Views/AuthenticationView.swift

import SwiftUI

struct AuthenticationView: View {
    @State private var showLoginScreen = true // Controla qual tela mostrar: Login ou o botão para Cadastro
    @State private var isShowingCadastroSheet = false // Controla a apresentação da sheet de Cadastro
    @Binding var usuarioAtual: Usuario? // Binding para o usuário logado

    var body: some View {
        VStack {
            if showLoginScreen {
                LoginView(usuarioAtual: $usuarioAtual, showLoginScreen: $showLoginScreen) // Passa showLoginScreen
            } else {
                // Mensagem ou placeholder quando não está na tela de login, mas ainda não cadastrou
                Text("Crie sua conta para começar!")
                    .font(.title2)
                    .padding()
            }

            // Botão para alternar entre Login/Cadastro ou abrir a sheet
            Button(action: {
                if showLoginScreen { // Se está na tela de login, o botão abre o cadastro
                    isShowingCadastroSheet = true
                } else { // Se não está na tela de login (após tentar abrir cadastro ou cancelar), o botão volta para login
                    showLoginScreen = true
                }
            }) {
                Text(showLoginScreen ? "Não tem uma conta? Cadastre-se!" : "Já tem uma conta? Faça Login!")
                    .font(.footnote)
                    .padding(.top, 20)
            }
        }
        // Apresenta a CadastroView como uma sheet
        .sheet(isPresented: $isShowingCadastroSheet) {
            // Este bloco é executado quando a sheet de CadastroView é dispensada
            showLoginScreen = true // Garante que, ao voltar, a tela de login seja exibida
        } content: {
            CadastroView()
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    @State static var previewUsuario: Usuario? = nil

    static var previews: some View {
        AuthenticationView(usuarioAtual: $previewUsuario)
            .modelContainer(for: [Usuario.self, Favorito.self], inMemory: true)
    }
}
