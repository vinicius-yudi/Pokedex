// Pokedex/Views/LoginView.swift

import SwiftUI
import SwiftData

struct LoginView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = LoginViewModel()
    @Binding var usuarioAtual: Usuario? // Binding para passar o usuário logado para a ContentView
    @Binding var showLoginScreen: Bool // NOVO BINDING: Para que LoginView possa mudar o estado em AuthenticationView

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Bem-vindo de volta, Treinador!")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 20)

                TextField("E-mail", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .disableAutocorrection(true)
                    .padding(.horizontal)

                SecureField("Senha", text: $viewModel.senha)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                if let errorMessage = viewModel.mensagemErro {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Button("Login") {
                    viewModel.fazerLogin()
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(AppColors.buttonPrimary)
                .cornerRadius(10)
                .padding(.horizontal)
                .onChange(of: viewModel.usuarioLogado) { oldUser, newUser in
                    if let loggedInUser = newUser {
                        usuarioAtual = loggedInUser // Define o usuário logado no binding
                        // showLoginView = false // REMOVIDO OU ADAPTADO: Não é mais showLoginView
                    }
                }
            }
            .padding()
            .onAppear {
                viewModel.setupDataManager(modelContext: modelContext)
            }
            .navigationTitle("Login")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        showLoginScreen = false // Volta para o estado onde "Crie sua conta!" aparece
                    }
                    .foregroundColor(AppColors.buttonPrimary)

                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    @State static var previewUsuario: Usuario? = nil
    @State static var previewShowLoginScreen = true // NOVO ESTADO PARA O BINDING

    static var previews: some View {
        LoginView(usuarioAtual: $previewUsuario, showLoginScreen: $previewShowLoginScreen) // Passa o novo binding
            .modelContainer(for: [Usuario.self, Favorito.self], inMemory: true)
    }
}
