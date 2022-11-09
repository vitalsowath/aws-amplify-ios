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
                    Task {
                        await login()
                    }
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
    
    func login() async {
        do {
            let result = try await Amplify.Auth.signIn(
                username: username,
                password: password
            )
            switch result.nextStep {
            case .done:
                print("login is done")
            default:
                print(result.nextStep)
            }
        } catch {
            print(error)
        }
    }
}
