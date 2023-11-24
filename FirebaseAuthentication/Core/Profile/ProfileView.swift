//
//  ProfileView.swift
//  FirebaseAuthentication
//
//  Created by Ованес Захарян on 23.11.2023.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
}

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        
        List {
            if let user = viewModel.user {
                Text("UserID: \(user.userId)")
                
                if let isAnonymous = user.isAnonymous {
                    Text("isAnonymous: \(isAnonymous.description.capitalized)")
                }
            }
            
            
        }
        .task {
            try? await self.viewModel.loadCurrentUser()
        }
        .navigationTitle("Профиль")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    SettingView(showSignInView: $showSignInView)
                } label: {
                    Image(systemName: "gear")
                        .font(.headline)
                }
            }
        }
        
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProfileView(showSignInView: (.constant(false)))
        }
       
    }
}


// 8:30
