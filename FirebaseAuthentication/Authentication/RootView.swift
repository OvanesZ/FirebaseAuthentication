//
//  RootView.swift
//  FirebaseAuthentication
//
//  Created by Ованес Захарян on 08.11.2023.
//

import SwiftUI

struct RootView: View {
    
    @State private var showSignInView = false
    
    var body: some View {
        
        ZStack {
            if !showSignInView {
                NavigationStack {
                    SettingView(showSignInView: $showSignInView)
                }
            }
        }
        .onAppear {
            let authuser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authuser == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
        
        
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
