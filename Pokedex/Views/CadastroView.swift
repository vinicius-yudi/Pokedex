//
//  CadastroView.swift
//  Pokedex
//
//  Created by user277066 on 6/12/25.
//

import SwiftUI
import SwiftData // Necessário para @Environment(\.modelContext)

struct CadastroView: View {
    @Environment(\.modelContext) private var modelContext // Obtém o contexto do SwiftData
    @StateObject private var viewModel = CadastroViewModel()
    @Environment(\.dismiss) var dismiss // Para fechar a sheet ou View após o cadastro

    var body: some View {
        NavigationView { // Adicione NavigationView para ter um título e botão de fechar
            VStack(spacing: 20) {
                Text("Crie sua conta Pokedex")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 20)

                TextField("Nome de Usuário", text: $viewModel.nomeDeUsuario)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.horizontal)

                TextField("E-mail", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .disableAutocorrection(true)
                    .padding(.horizontal)

                SecureField("Senha", text: $viewModel.senha)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                SecureField("Confirmar Senha", text: $viewModel.confirmarSenha)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                if let errorMessage = viewModel.mensagemErro {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Button("Cadastrar") {
                    viewModel.registrarUsuario()
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
                .padding(.horizontal)
                .alert("Sucesso!", isPresented: $viewModel.cadastroSucesso) {
                    Button("OK") {
                        dismiss() // Fecha a tela de cadastro
                    }
                } message: {
                    Text("Usuário cadastrado com sucesso! Agora você pode fazer login.")
                }
            }
            .padding()
            .onAppear {
                // Configura o DataManager do ViewModel com o ModelContext
                viewModel.setupDataManager(modelContext: modelContext)
            }
            .navigationTitle("Cadastro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct CadastroView_Previews: PreviewProvider {
    static var previews: some View {
        CadastroView()
            .modelContainer(for: [Usuario.self, Favorito.self], inMemory: true) // Para o preview
    }
}
