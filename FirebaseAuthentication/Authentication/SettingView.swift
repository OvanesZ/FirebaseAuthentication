//
//  SettingView.swift
//  FirebaseAuthentication
//
//  Created by Ованес Захарян on 08.11.2023.
//

import SwiftUI


@MainActor
final class SettingsViewModel: ObservableObject {
    
    @Published var authProviders: [AuthProviderOption] = []
    
    func loadAuthProviders() {
        if let providers = try? AuthenticationManager.shared.getProviders() {
            authProviders = providers
        }
    }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updateEmail() async throws {
        let email = "test@google.com"
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
    func updatePassword() async throws {
        let password = "111111"
        try await AuthenticationManager.shared.updateEmail(email: password)
    }
    
}



struct SettingView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {

        List {
            Button("Выйти из аккаунта") {
                Task {
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            }
            
            if viewModel.authProviders.contains(.email) {
                emailSection
            }
            

            
            
        }
        .onAppear {
            viewModel.loadAuthProviders()
        }
        .navigationTitle("Settings")
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingView(showSignInView: .constant(false))
        }
    }
}


extension SettingView {
    private var emailSection: some View {
        Section {
            Button("Сбросить пароль") {
                Task {
                    do {
                        try await viewModel.resetPassword()
                        print("Password reset!")
                    } catch {
                        print(error)
                    }
                }
            }
            
            Button("Обновить пароль") {
                Task {
                    do {
                        try await viewModel.updatePassword()
                        print("Password reset!")
                    } catch {
                        print(error)
                    }
                }
            }
            
            Button("Обновить email") {
                Task {
                    do {
                        try await viewModel.updateEmail()
                        print("Password reset!")
                    } catch {
                        print(error)
                    }
                }
            }
        } header: {
            Text("Функции электронной почты")
        }
    }
}
