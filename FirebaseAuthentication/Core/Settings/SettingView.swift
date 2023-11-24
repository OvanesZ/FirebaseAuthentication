//
//  SettingView.swift
//  FirebaseAuthentication
//
//  Created by Ованес Захарян on 08.11.2023.
//

import SwiftUI






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
            
            if viewModel.authUser?.isAnonymous == true {
                anonymousSection
            }

            
            
        }
        .onAppear {
            viewModel.loadAuthProviders()
            viewModel.loadAuthUser()
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
    
    private var anonymousSection: some View {
        Section {
            Button("Связать с аккаунтом Google") {
                Task {
                    do {
                        try await viewModel.linkGoogleAccount()
                        print("Link Google!")
                    } catch {
                        print(error)
                    }
                }
            }
            
            Button("Связать с аккаунтом Apple") {
                Task {
                    do {
                        try await viewModel.linkAppleAccount()
                        print("Link Apple!")
                    } catch {
                        print(error)
                    }
                }
            }
            
            Button("Связать с аккаунтом Email") {
                Task {
                    do {
                        try await viewModel.linkEmailAccount()
                        print("Link Email!")
                    } catch {
                        print(error)
                    }
                }
            }
        } header: {
            Text("Связать анонимный аккаунт с ")
        }
    }
}
