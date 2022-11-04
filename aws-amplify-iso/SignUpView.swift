//
//  SignUpView.swift
//  aws-amplify-iso
//
//  Created by Vital SOWATH on 4/11/22.
//

import Amplify
import SwiftUI

struct SignUpView: View {
    
    let showLogin: () -> Void
    
    @State var username: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var shouldShowConfirmSignUp: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            TextField("Username", text: $username)
            TextField("Email", text: $email)
            SecureField("Password", text: $password)
            Button("Sign Up", action: {
                signUp()
            })
            Spacer()
            Button("Already have an account? Login.", action: showLogin)
        }
        .navigationDestination(isPresented: .constant(shouldShowConfirmSignUp)) {
            ConfirmSignUpView(username: username)
        }
    }
    
    func signUp() {
        
        let userAttributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(
            userAttributes: userAttributes
        )
       
        Amplify.Auth.signUp(username: username, password: password, options: options) { result in
            switch result {
            case .success(let signUpResult):
                if case let .confirmUser(deliveryDetails, _) = signUpResult.nextStep {
                    self.shouldShowConfirmSignUp = true
                    print("Delivery details \(String(describing: deliveryDetails))")
                } else {
                    print("SignUp Complete")
                }
            case .failure(let error):
                print("An error occurred while signUp a user \(error)")
            }
        }
    }
}

