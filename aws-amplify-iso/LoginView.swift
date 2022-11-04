//
//  LoginView.swift
//  aws-amplify-iso
//
//  Created by Vital SOWATH on 4/11/22.
//

import Amplify
import SwiftUI

struct LoginView: View {
    
    @State var username: String = ""
    @State var password: String = ""
    
    @State var shouldShowSignUp: Bool = false
    var body: some View{
        NavigationStack {
            VStack{
                Spacer()
                TextField("Username", text: $username)
                SecureField("Password", text: $password)
                Button("Log In", action: {
                    login()
                })
                Spacer()
                Button("Don't have an account? Sign up.", action: { shouldShowSignUp = true })
                    .navigationDestination(isPresented: $shouldShowSignUp) {
                        SignUpView(showLogin: { shouldShowSignUp = false })
                            .navigationBarBackButtonHidden(true)
                    }
            }
        }
    }
    
    func login() {
        Amplify.Auth.signIn(username: username, password: password) { result in
            switch result {
            case .success(let signInResult):
                if case .done = signInResult.nextStep {
                    print("login is done")
                } else {
                    print(signInResult.nextStep)
                }
            case .failure(let error):
                print("An error occurred while signIn a user \(error)")
            }
        }
    }
}
