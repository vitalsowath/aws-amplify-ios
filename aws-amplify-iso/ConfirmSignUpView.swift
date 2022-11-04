//
//  ConfirmSignUpView.swift
//  aws-amplify-iso
//
//  Created by Vital SOWATH on 4/11/22.
//

import Amplify
import SwiftUI

struct ConfirmSignUpView: View {
    
    let username: String
    
    @State var confirmationCode: String = ""
    @State var shouldShowLogin: Bool = false
    
    var body: some View {
        VStack {
            TextField("Verification Code", text: $confirmationCode)
            Button("Submit", action: {
                 confirmSignUp()
            })
        }
        .navigationDestination(isPresented: .constant(shouldShowLogin)) {
            LoginView()
        }
    }
    
    func confirmSignUp() {
        _ = Amplify.Auth.confirmSignUp(for: username, confirmationCode: confirmationCode) { result in
            switch result {
            case .success(let confirmResult):
                switch confirmResult.nextStep {
                case .done:
                    DispatchQueue.main.async {
                        self.shouldShowLogin = true
                    }
                default:
                    print(confirmResult.nextStep)
                }
            case .failure(let error):
                print("An error occurred while confirm a user \(error)")
            }   
        }
    }
}
