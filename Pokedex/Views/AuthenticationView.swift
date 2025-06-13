
import SwiftUI

struct AuthenticationView: View {
    @State private var showLoginScreen = true
    @State private var isShowingCadastroSheet = false
    @Binding var usuarioAtual: Usuario?

    var body: some View {
        VStack {
            if showLoginScreen {
                LoginView(usuarioAtual: $usuarioAtual, showLoginScreen: $showLoginScreen) // Passa showLoginScreen
            } else {
                Text("Crie sua conta para começar!")
                    .font(.title2)
                    .padding()
            }

            Button(action: {
                if showLoginScreen {
                    isShowingCadastroSheet = true
                } else {
                    showLoginScreen = true
                }
            }) {
                Text(showLoginScreen ? "Não tem uma conta? Cadastre-se!" : "Já tem uma conta? Faça Login!")
                    .font(.footnote)
                    .padding(.top, 20)
                    .foregroundColor(AppColors.buttonPrimary)

            }
        }
        .sheet(isPresented: $isShowingCadastroSheet) {
            showLoginScreen = true
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
